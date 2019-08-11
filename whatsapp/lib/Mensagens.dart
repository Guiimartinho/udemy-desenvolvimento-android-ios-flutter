import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Mensagens extends StatefulWidget {

  Usuario contato;
  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  String _idUsusarioLogado;
  String _idUsusarioDestinario;

  List<String> listaMensagens = [
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
    "Olá, tudo bem?",
  ];
  TextEditingController _controllerMensagem = TextEditingController();

  _enviarMensagem(){

    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsusarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";

      _salvarMensagem(_idUsusarioLogado, _idUsusarioDestinario, mensagem);

    }

  }

  _salvarMensagem(String idRemetente, String idDestinatario, Mensagem msg) async{

    Firestore db = Firestore.instance;

    await db.collection("mensagens")
      .document(idRemetente)
      .collection(idDestinatario)
      .add( msg.toMap() );

      //Limpar mensagem
      _controllerMensagem.clear();

    /*
    + mensagens
      + anderson melo
        + contato
          + identificadorFirebase
            <Mensagme>
    */

  }

  _enviarFoto(){
  
  }

  _recuperarDadosUsuario() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado =  await auth.currentUser();
    _idUsusarioLogado = usuarioLogado.uid;

    _idUsusarioDestinario = widget.contato.idUsuario;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {

    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                    controller: _controllerMensagem,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                      hintText: "Digite uma mensagem...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36)
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _enviarFoto
                      )
                    ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(Icons.send, color: Colors.white),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
        itemCount: listaMensagens.length,
        itemBuilder: (context, indice){

          double larguraContainer = MediaQuery.of(context).size.width * 0.8;

          //Define cores e alinhamentos
          Alignment alinhamento = Alignment.centerRight;
          Color cor = Color(0xffd2ffa5);

          if(indice % 2 == 0){
             alinhamento = Alignment.centerLeft;
             cor = Color(0xfffafafa);
          }

          return Align(
            alignment: alinhamento,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Container(
                width: larguraContainer,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Text(
                  listaMensagens[indice],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );

        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: widget.contato.urlImagem != null
              ? NetworkImage(widget.contato.urlImagem)
              : null
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contato.nome),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  //listview
                  listView,
                  //caixa mensagem
                  caixaMensagem,
                ],
              ),
            ),
        ),
      ),
    );
  }
}