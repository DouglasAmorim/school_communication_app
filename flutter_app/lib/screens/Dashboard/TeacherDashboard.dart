import 'package:flutter/material.dart';
import 'package:tcc_ifsc/models/ApiImpl.dart';
import 'package:tcc_ifsc/models/ContactsItemList.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:tcc_ifsc/models/Estudante.dart';
import 'package:tcc_ifsc/models/Parents.dart';
import 'package:tcc_ifsc/models/Professor.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';

const _tituloAppBar = 'Dashboard';


class TeacherDashboard extends StatefulWidget {
  final Professor teacher;
  final List<Estudante> _estudanteList = [];
  final List<Parents> _parentsList = [];
  var _getContacts = true;
  final List<EstruturaMensagem> _messages = [];

  TeacherDashboard({Key? key, required this.teacher}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TeacherDashboardState();
  }
}

class TeacherDashboardState extends State<TeacherDashboard> {
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
                itemCount: widget._estudanteList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,

                itemBuilder: (context, indice) {
                  final contact = widget._estudanteList[indice];

                  final List<EstruturaMensagem> lista = [];

                  print(widget._messages.length);

                  for(var i = 0; i < widget._messages.length; i ++){
                    print(widget._messages[i].contactId);
                    print(widget._messages[i].contactType);
                    print(widget._messages[i].mensagem);
                    if(widget._messages[i].contactId == contact.id && widget._messages[i].contactType == contact.type) {
                      print("Adicionando mensagem a lista do contato");
                      lista.add(widget._messages[i]);
                    }
                  }

                  return ContactsItemList(contact.name, contact.queueId, widget.teacher.id, contact.id, lista ,widget.teacher.name, widget.teacher.type, contact.type);
                },
              ),

              // Parents List
              ListView.builder(
                itemCount: widget._parentsList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,

                itemBuilder: (context, indice) {
                  final contact = widget._parentsList[indice];

                  final List<EstruturaMensagem> lista = [];

                  print(widget._messages.length);

                  for(var i = 0; i < widget._messages.length; i ++){
                    print(widget._messages[i].contactId);
                    print(widget._messages[i].contactType);
                    print(widget._messages[i].mensagem);
                    if(widget._messages[i].contactId == contact.id && widget._messages[i].contactType == contact.type) {
                      print("Adicionando mensagem a lista do contato");
                      lista.add(widget._messages[i]);
                    }
                  }

                  return ContactsItemList(contact.name, contact.queueId, widget.teacher.id, contact.id, lista, widget.teacher.name, widget.teacher.type, contact.type);
                },
              )
            ],
          ),
        ),
    );
  }

  void _getReceivedMessages() {
    final String url = "http://localhost:5000/professor/messages/received/${widget.teacher.id}";
    ApiImpl().getCaixaProfessores(url).then((value) {
      for(var i = 0; i < value.length; i++) {
        var id = 0;
        var contactType = typeEnum.teacher;

        if(value[i].alunosId != 0) {
          id = value[i].alunosId;
          contactType = typeEnum.student;
        } else if(value[i].paisId != 0) {
          id = value[i].paisId;
          contactType = typeEnum.parents;
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
    var url = "http://localhost:5000/professor/messages/send/alunos/${widget.teacher.id}";
    ApiImpl().getCaixaAlunos(url).then((value) {

      for(var i = 0; i < value.length; i++) {
        var contactType = typeEnum.student;

        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: false, contactId: value[i].id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });

    url = "http://localhost:5000/professor/messages/send/pais/${widget.teacher.id}";
    ApiImpl().getCaixaPais(url).then((value) {

      for(var i = 0; i < value.length; i++) {
        var contactType = typeEnum.parents;

        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: false, contactId: value[i].id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });

    url = "http://localhost:5000/professor/messages/send/escola/${widget.teacher.id}";
    ApiImpl().getCaixaEscola(url).then((value) {

      for(var i = 0; i < value.length; i++) {
        var contactType = typeEnum.school;

        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: false, contactId: value[i].id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });
  }


  void _getContactsList() {

    final id = widget.teacher.id;
    final future = ApiImpl().teacherContactsAlunos(id).then((value) => {
      for(var i =0; i < value.length; i++) {
        setState(() {
          print("set estudante ${value[i].name}");
          widget._estudanteList.add(value[i]);
        })
      }
    });

    final _ = ApiImpl().teacherContactsParents(id).then((value) => {
      for(var i =0; i < value.length; i++) {
        setState(() {
          print("set parents ${value[i].name}");
          widget._parentsList.add(value[i]);
        })
      }
    });

    widget._getContacts = false;
  }
}