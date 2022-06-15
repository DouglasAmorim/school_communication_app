import 'package:flutter/material.dart';
import '../../screens/Mensagem/Mensagem.dart';
import '/models/Users/User.dart';

class ContactItemCell extends StatelessWidget {
  final ContactData user;

  ContactItemCell(this.user);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(user.name),
        onTap: () {
          // TODO: Implementar Redirecionamento para tela mensagens
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //
          // }));
        },
      ),
    );
    throw UnimplementedError();
  }
}