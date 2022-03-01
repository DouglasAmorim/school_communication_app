import 'package:flutter/material.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/screens/Mensagem/Mensagem.dart';

class ContactsItemList extends StatelessWidget {
  final List<String> mensagens;
  final String destinatarioNome;
  final String remetenteNome;
  final int destinatarioQueueId;
  final int destinatarioId;
  final int remetenteId;
  final typeEnum remetenteType;
  final typeEnum destinatarioType;

  ContactsItemList(this.destinatarioNome, this.destinatarioQueueId, this.remetenteId, this.destinatarioId, this.mensagens, this.remetenteNome, this.remetenteType, this.destinatarioType);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(destinatarioNome),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Mensagem(remetenteId: this.remetenteId, remetenteNome: this.remetenteNome, destinatarioQueueId: this.destinatarioQueueId, destinatarioId: this.destinatarioId, destinatarioNome: this.destinatarioNome, mensagens: this.mensagens, remetenteType: this.remetenteType, destinatarioType: this.destinatarioType,);
          }));
        },
      ),
    );
    throw UnimplementedError();
  }
}