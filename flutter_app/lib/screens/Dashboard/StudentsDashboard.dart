import 'package:flutter/material.dart';
import 'package:tcc_ifsc/models/ApiImpl.dart';
import 'package:tcc_ifsc/models/ContactsItemList.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:tcc_ifsc/models/Estudante.dart';
import 'package:tcc_ifsc/models/Parents.dart';
import 'package:tcc_ifsc/models/Professor.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';

const _tituloAppBar = 'Dashboard';


class StudentsDashboard extends StatefulWidget {
  final Estudante estudante;
  final List<Professor> _professorList = [];
  var _getContacts = true;
  final List<EstruturaMensagem> _messages = [];

  StudentsDashboard({Key? key, required this.estudante}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StudentsDashboardState();
  }
}

class StudentsDashboardState extends State<StudentsDashboard> {
  @override
  Widget build(BuildContext context) {
    if(widget._getContacts) {
      _getReceivedMessages();
      _getSendMessages();
      _getContactsList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Students List
            ListView.builder(
              itemCount: widget._professorList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,

              itemBuilder: (context, indice) {
                final contact = widget._professorList[indice];

                final List<EstruturaMensagem> lista = [];

                for(var i = 0; i < widget._messages.length; i ++){

                  if(widget._messages[i].contactId == contact.id && widget._messages[i].contactType == contact.type) {
                    print("Adicionando mensagem a lista do contato");
                    lista.add(widget._messages[i]);
                  }
                }

                return ContactsItemList(contact.name, contact.queueId, widget.estudante.id, contact.id, lista ,widget.estudante.name, widget.estudante.type, contact.type);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getReceivedMessages() {
    final String url = "http://localhost:5000/alunos/messages/received/${widget.estudante.id}";
    ApiImpl().getCaixaAlunos(url).then((value) {
      for(var i = 0; i < value.length; i++) {
        var id = 0;
        var contactType = typeEnum.teacher;

        if(value[i].schoolId != 0) {
          id = value[i].schoolId;
          contactType = typeEnum.school;
        } else if(value[i].professoresId != 0) {
          id = value[i].professoresId;
          contactType = typeEnum.teacher;
        } else {
          id = value[i].schoolId;
          contactType = typeEnum.school;
        }
        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: true, contactId: id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });
  }

  void _getSendMessages() {
    var url = "http://localhost:5000/alunos/messages/send/professores/${widget.estudante.id}";
    ApiImpl().getCaixaProfessores(url).then((value) {

      for(var i = 0; i < value.length; i++) {
        var contactType = typeEnum.teacher;

        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: false, contactId: value[i].id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });

    url = "http://localhost:5000/alunos/messages/send/school/${widget.estudante.id}";
    ApiImpl().getCaixaEscola(url).then((value) {

      for(var i = 0; i < value.length; i++) {
        var contactType = typeEnum.school;

        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: false, contactId: value[i].id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });
  }


  void _getContactsList() {

    final id = widget.estudante.id;
    final future = ApiImpl().alunosContacts(id).then((value) => {
      for(var i =0; i < value.length; i++) {
        setState(() {
          widget._professorList.add(value[i]);
        })
      }
    });
    widget._getContacts = false;
  }
}