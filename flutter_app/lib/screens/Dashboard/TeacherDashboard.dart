import 'package:flutter/material.dart';
import 'package:tcc_ifsc/models/ApiImpl.dart';
import 'package:tcc_ifsc/models/ContactsItemList.dart';
import 'package:tcc_ifsc/models/Estudante.dart';
import 'package:tcc_ifsc/models/Parents.dart';
import 'package:tcc_ifsc/models/Professor.dart';

const _tituloAppBar = 'Dashboard';


class TeacherDashboard extends StatefulWidget {
  final Professor teacher;
  final List<Estudante> _estudanteList = [];
  final List<Parents> _parentsList = [];
  var _getContacts = true;

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
                  return ContactsItemList(contact.name);
                },
              ),

              // Parents List
              ListView.builder(
                itemCount: widget._parentsList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,

                itemBuilder: (context, indice) {
                  final contact = widget._parentsList[indice];
                  return ContactsItemList(contact.name);
                },
              )
            ],
          ),
        ),
    );
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