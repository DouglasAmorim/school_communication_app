import 'package:flutter/material.dart';
import 'package:tcc_ifsc/models/ApiImpl.dart';
import 'package:tcc_ifsc/models/ContactsItemList.dart';
import 'package:tcc_ifsc/models/Estudante.dart';
import 'package:tcc_ifsc/models/Parents.dart';
import 'package:tcc_ifsc/models/Professor.dart';

const _tituloAppBar = 'Dashboard';


class ParentsDashboard extends StatefulWidget {
  final Parents parents;
  final List<Professor> _professorList = [];
  var _getContacts = true;

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
                return ContactsItemList(contact.name, contact.queueId, widget.parents.id, contact.id, [] ,widget.parents.name, widget.parents.type, contact.type);
              },
            ),
          ],
        ),
      ),
    );
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