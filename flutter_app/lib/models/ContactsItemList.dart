import 'package:flutter/material.dart';
import 'package:tcc_ifsc/screens/Mensagem/Mensagem.dart';

class ContactsItemList extends StatelessWidget {
  final String _contactName;

  ContactsItemList(this._contactName);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(_contactName),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Mensagem();
          }));
        },
      ),
    );
    throw UnimplementedError();
  }
}