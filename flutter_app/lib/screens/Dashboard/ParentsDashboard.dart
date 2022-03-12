import 'package:flutter/material.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/models/ApiImplementations/ApiImpl.dart';
import 'package:tcc_ifsc/models/ContactsItemList.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:tcc_ifsc/models/Users/Estudante.dart';
import 'package:tcc_ifsc/models/Users/Parents.dart';
import 'package:tcc_ifsc/models/Users/Professor.dart';

const _tituloAppBar = 'Dashboard';


class ParentsDashboard extends StatefulWidget {
  final Parents parents;
  final List<Professor> _professorList = [];
  var _getContacts = true;
  final List<EstruturaMensagem> _messages = [];

  ParentsDashboard({Key? key, required this.parents}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ParentsDashboardState();
  }
}

class ParentsDashboardState extends State<ParentsDashboard> {
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
                return ContactsItemList(contact.name, contact.queueId, widget.parents.id, contact.id, lista,widget.parents.name, widget.parents.type, contact.type);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getReceivedMessages() {
    final String url = "http://localhost:5000/pais/messages/received/${widget.parents.id}";
    ApiImpl().getCaixaPais(url).then((value) {
      for(var i = 0; i < value.length; i++) {
        var id = 0;
        var contactType = typeEnum.teacher;

        if(value[i].alunosId != 0) {
          id = value[i].alunosId;
          contactType = typeEnum.student;
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
    var url = "http://localhost:5000/pais/messages/send/professores/${widget.parents.id}";
    ApiImpl().getCaixaProfessores(url).then((value) {
      for(var i = 0; i < value.length; i++) {
        var contactType = typeEnum.teacher;

        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: false, contactId: value[i].id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });

    url = "http://localhost:5000/pais/messages/send/school/${widget.parents.id}";
    ApiImpl().getCaixaEscola(url).then((value) {
      for(var i = 0; i < value.length; i++) {
        var contactType = typeEnum.school;

        final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: value[i].mensagem, date: value[i].date, isReceived: false, contactId: value[i].id, contactType: contactType);
        widget._messages.add(estrutura);
      }
    });
  }

  void _getContactsList() {

    final id = widget.parents.id;
    final future = ApiImpl().parentsContacts(id).then((value) => {
      for(var i =0; i < value.length; i++) {
        setState(() {
          widget._professorList.add(value[i]);
        })
      }
    });
    widget._getContacts = false;
  }
}