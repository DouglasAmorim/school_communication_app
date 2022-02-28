import 'package:flutter/material.dart';
import 'package:tcc_ifsc/components/Editor.dart';
import 'package:tcc_ifsc/models/ApiImpl.dart';

const _tituloAppBar = 'Dashboard';
const _dicaCampoMensagem = 'olá ! ';
const _rotuloCampoMensagem = 'Nova Mensagem';
const _textoBotaoConfirmar = 'Enviar';

class Mensagem extends StatefulWidget {
  final List<String> _mensagens = ["oi", "tudo bom ?"];
  Mensagem({Key? key}) : super(key: key);

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
              itemCount: widget._mensagens.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, indice) {
                final contactName = widget._mensagens[indice];
                return MensagensItemList(contactName);
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

  void _envioMensagem(BuildContext context) {
    final String? mensagem = _controllerMensagem.text;
    // TODO: Tratar envio da mensagem

    ApiImpl().sendMessageToAluno();

    if(mensagem != null) {
      setState(() {
        widget._mensagens.add(mensagem);
        _controllerMensagem.text = "";
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
    throw UnimplementedError();
  }
}