import 'package:flutter/material.dart';
import '../../screens/Mensagem/Mensagem.dart';
import '/models/Users/User.dart';

class ContactItemCell extends StatelessWidget {

  final ContactData userContact;
  final UserData userData;
  ContactItemCell(this.userContact, this.userData);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(userContact.name),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Mensagem(messages: this.userContact.messages,
                receiverQueueId: this.userContact.id,
                receiverName: this.userContact.name,
                typeReceiver: this.userContact.type,
                senderQueueId: this.userData.id,
                senderName: this.userData.name,
                typeSender: this.userData.type);
          }));
        },
      ),
    );
    throw UnimplementedError();
  }
}

class EmptyItemCell extends StatelessWidget {
  final ContactData userContact;
  final UserData userData;
  EmptyItemCell(this.userContact, this.userData);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: Icon(Icons.school),
          title: Text("Entre em contato com a Instituição de Ensino \nPara que seja finalizado seu cadastro."),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Mensagem(messages: this.userContact.messages,
                  receiverQueueId: this.userContact.id,
                  receiverName: this.userContact.name,
                  typeReceiver: this.userContact.type,
                  senderQueueId: this.userData.id,
                  senderName: this.userData.name,
                  typeSender: this.userData.type);
            }));
          },
        ),
    );
  }
}