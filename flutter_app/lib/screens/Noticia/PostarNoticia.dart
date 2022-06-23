import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_ifsc/screens/Noticia/EnviarNoticia.dart';
import '../../models/EstruturaGrupoNoticia.dart';
import '../../models/Users/User.dart';

class PostarNoticia extends StatefulWidget {
  final UserData user;
  List<EstruturaGrupoNoticia> gruposNoticias = [];

  PostarNoticia({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PostarNoticiaState();
  }
}

class PostarNoticiaState extends State<PostarNoticia> {

  @override
  void initState() {
    _criarListaGrupos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Postar Noticia"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.gruposNoticias.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, indice) {
                final grupo = widget.gruposNoticias[indice];

                return PostarNoticiaItemList(widget.user, grupo.nome, grupo.queueId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _criarListaGrupos() {
    List<EstruturaGrupoNoticia> grupo = [];
    for(int i = 0; i < widget.user.turma.length; i++){
      grupo.add(EstruturaGrupoNoticia(nome: "Turma ${widget.user.turma[i]} Alunos", queueId: "topicNoticiasTurmaAlunos${widget.user.turma[i]}"));
      grupo.add(EstruturaGrupoNoticia(nome: "Turma ${widget.user.turma[i]} Pais", queueId: "topicNoticiasTurmaPais${widget.user.turma[i]}"));
      grupo.add(EstruturaGrupoNoticia(nome: "Turma ${widget.user.turma[i]} Geral", queueId: "topicNoticiasTurma${widget.user.turma[i]}"));
    }

    grupo.add(EstruturaGrupoNoticia(nome: "Noticia Geral", queueId: "topicNoticiasEscola"));

    setState(() {
      widget.gruposNoticias = grupo;
    });
  }
}

class PostarNoticiaItemList extends StatelessWidget {
  final String _grupoNoticiaQueue;
  final String _grupoNoticiaNome;
  final UserData user;
  PostarNoticiaItemList(this.user, this._grupoNoticiaNome, this._grupoNoticiaQueue);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.group),
        title: Text(_grupoNoticiaNome),
        onTap: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EnviarNoticia(user: this.user, grupo: this._grupoNoticiaQueue);

          }));
        },
      ),
    );
  }
}

