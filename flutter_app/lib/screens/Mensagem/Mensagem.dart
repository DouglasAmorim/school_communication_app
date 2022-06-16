import 'package:flutter/material.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/components/Editor.dart';
import 'package:tcc_ifsc/models/ApiImplementations/ApiImpl.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';

const _labelMessageField = 'Nova Mensagem';
const _sendButtonText = 'Enviar';

class Mensagem extends StatefulWidget {
  final List<EstruturaMensagem> messages;

  final String receiverName;
  final String senderName;
  final String receiverQueueId;
  final String senderQueueId;
  final String typeSender;
  final String typeReceiver;

  Mensagem({Key? key, required this.messages, required this.receiverQueueId, required this.receiverName, required this.typeReceiver, required this.senderQueueId, required this.senderName, required this.typeSender}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MensagemState();
  }
}

class MensagemState extends State<Mensagem> {
  final TextEditingController _controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              itemCount: widget.messages.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, indice) {
                final contactName = widget.messages[indice];
                return MensagensItemList(contactName.message!);
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: TextField(
        controller: _controllerMessage,
        decoration: InputDecoration(
          hintText: _labelMessageField,
          suffixIcon: IconButton(
            onPressed: () => _envioMensagem(context),
            icon: Icon(Icons.send),
          ),
        ),
      ),
    );
  }

  void _envioMensagem(BuildContext context) {
    final String? message = _controllerMessage.text;

    // TODO: Tratar envio da mensagem
    if(message != null) {
    }
  }
}

class MensagensItemList extends StatelessWidget {
  final String _message;

  MensagensItemList(this._message);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(_message),
      ),
    );
  }
}