import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {

  Future<Map> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot){
        String resultado;
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            print("conexao waiting");
            resultado = "Carregando...";
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            print("conexao done");
            if(snapshot.hasError){
              resultado = "Erro ao carregar os dados";
            }else{
              double valor = snapshot.data["BRL"]["buy"];
              resultado = "Preço do bitcoin: R\$ ${valor.toString()}";
            }
            break;
        }
        return Center(
          child: Text(
            resultado, 
            style: TextStyle(
              fontSize: 25, 
              color: Colors.blue
              ), 
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }
}