import 'package:flutter/material.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/components/Editor.dart';
import 'package:tcc_ifsc/models/ApiImplementations/ApiImpl.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:intl/intl.dart';
import 'package:tcc_ifsc/models/Storage/FileHandler.dart';

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
                final message = widget.messages[indice];
                Color color = Colors.white;

                if (message.senderId != widget.senderQueueId) {
                  color = Colors.greenAccent;
                }

                return MensagensItemList(message.message, color);
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

    if(message != null) {

      final EstruturaMensagem msg = EstruturaMensagem(
          message: message,
          date: DateFormat('kk:mm:ss \n EEE d MMM yyyy').format(DateTime.now()),
          senderId: widget.senderQueueId,
          senderName: widget.senderName,
          senderType: widget.typeSender,
          receiverId: widget.receiverQueueId,
          receiverName: widget.receiverName,
          receiverType: widget.typeReceiver,
      );

      ApiImpl().sendNotification(msg).then((value) => {
        FileHandler.instance.writeMessages(msg),
        _controllerMessage.clear(),
        setState(() {
          widget.messages.add(msg);
        }),
      });
    }
  }
}

class MensagensItemList extends StatelessWidget {
  final String _message;
  final Color _color;

  MensagensItemList(this._message, this._color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(_message),
      ),
      color: _color,
    );
  }
}