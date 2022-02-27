import 'package:flutter/material.dart';
import 'package:tcc_ifsc/models/ContactsItemList.dart';
import 'package:tcc_ifsc/models/Professor.dart';

const _tituloAppBar = 'Dashboard';

class Dashboard extends StatefulWidget {
  final Professor teacher;
  final List<String> _contatos = ["banana", "banana3", "antonio"];
  Dashboard({Key? key, required this.teacher}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_tituloAppBar),
        ),

        body: ListView.builder(
          itemCount: widget._contatos.length,
          itemBuilder: (context, indice) {
            final contactName = widget._contatos[indice];
            return ContactsItemList(contactName);
          },
        )

    );
  }
}