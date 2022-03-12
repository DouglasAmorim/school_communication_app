import 'package:flutter/material.dart';
import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/components/Editor.dart';
import 'package:tcc_ifsc/models/ApiImplementations/ApiImpl.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';

const _tituloAppBar = 'Dashboard';
const _dicaCampoMensagem = 'olá ! ';
const _rotuloCampoMensagem = 'Nova Mensagem';
const _textoBotaoConfirmar = 'Enviar';

class Mensagem extends StatefulWidget {
  final List<EstruturaMensagem> mensagens;
  final String destinatarioNome;
  final String remetenteNome;
  final int destinatarioQueueId;
  final int destinatarioId;
  final int remetenteId;
  final typeEnum remetenteType;
  final typeEnum destinatarioType;

  Mensagem({Key? key, required this.mensagens, required this.destinatarioId, required this.destinatarioNome, required this.destinatarioQueueId, required this.remetenteId, required this.remetenteNome, required this.remetenteType, required this.destinatarioType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MensagemState();
  }
}


class MensagemState extends State<Mensagem> {
  final TextEditingController _controllerMensagem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_tituloAppBar),
        ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              itemCount: widget.mensagens.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, indice) {
                final contactName = widget.mensagens[indice];
                return MensagensItemList(contactName.mensagem!);
              },
            ),
            Editor(controller: _controllerMensagem, dica: _dicaCampoMensagem , rotulo: _rotuloCampoMensagem),
            ElevatedButton(
              onPressed: () => _envioMensagem(context),
              child: Text(_textoBotaoConfirmar),

            ),
          ],
        ),
      ),
    );
  }

  String getDestinatario() {
    switch(widget.destinatarioType) {
      case typeEnum.school:
        return "escola";
      case typeEnum.parents:
        return "pais";
      case typeEnum.student:
        return "alunos";
      case typeEnum.teacher:
        return "professores";
      default:
        return "escola";
    }
  }

  String getRemetente() {
    switch(widget.remetenteType) {
      case typeEnum.teacher:
        return "professor";
      case typeEnum.parents:
        return "pais";
      case typeEnum.student:
        return "alunos";
      case typeEnum.school:
        return "escola";
      default:
        return "alunos";

    }
  }

  void _envioMensagem(BuildContext context) {
    final String? mensagem = _controllerMensagem.text;
    // TODO: Tratar envio da mensagem
    if(mensagem != null) {

      final String url = "http://localhost:5000/${getRemetente()}/send/${getDestinatario()}";

      ApiImpl().sendMessage(url, widget.destinatarioId, widget.destinatarioQueueId, widget.remetenteNome, widget.remetenteId, mensagem).then((value) {
        if(value) {
          setState(() {
            final EstruturaMensagem estrutura = EstruturaMensagem(mensagem: mensagem, date: 'now', isReceived: false, contactId: widget.destinatarioId, contactType: widget.destinatarioType);
            widget.mensagens.add(estrutura);
            _controllerMensagem.text = "";
          });
        } else {
          // TODO: SHOW ERROR MESSAGE
        }
      });
    }
  }
}

class MensagensItemList extends StatelessWidget {
  final String _mensagem;

  MensagensItemList(this._mensagem);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(_mensagem),
      ),
    );
  }
}