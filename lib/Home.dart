import "package:mask_text_input_formatter/mask_text_input_formatter.dart";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var maskFormatter = new MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });
  TextEditingController _controllerCep = TextEditingController();
  String _resultado = "Resultado";
  
  _recuperarCep() async {

    String cepDigitado = _controllerCep.text;
    String url = "https://viacep.com.br/ws/${cepDigitado}/json/";
    http.Response response;

    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode( response.body );
    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];

    setState(() {
      _resultado = "${logradouro}, ${complemento}, ${bairro} ";
    });

    print(
      "Resposta logradouro: ${logradouro} complemento: ${complemento} bairro: ${bairro} "
    );

    //print("resposta: " + response.statusCode.toString() );
    //print("resposta: " + response.body );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço web"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            TextField(
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite o cep: ex: 05428-200"
              ),
              style: TextStyle(
                fontSize: 20
              ),
              controller: _controllerCep,
            ),
            RaisedButton(
              child: Text("Clique aqui"),
              onPressed: _recuperarCep,
            ),
            Text( _resultado )
          ],
        ),
      ),
    );
  }
}
