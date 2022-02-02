import 'package:flutter/material.dart';
import 'package:tcc_ifsc/models/Transferencia.dart';
import 'Formulario.dart';

const _tituloAppBar = "Transferencias";


class MessageList extends StatefulWidget {
  final List<String> _messages = [];
  @override
  State<StatefulWidget> createState() {
    return MessageListState();
  }
}

class ListaTransferencias extends StatefulWidget {

  final List<Transferencia?> _transferencias = [];
  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: ListView.builder(
        itemCount: widget._messages.length,
        itemBuilder: (context, indice) {
          final message = widget._messages[indice];
          return ItemList(message);
        },
      ),

      persistentFooterButtons: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SendMessage();
              })).then((value) => _atualiza(value));
            },
            child: Text("SEND_MESSAGE"),
        )
      ],
    );
    // TODO: implement build
    throw UnimplementedError();
  }

  void _atualiza(String? valueReceived) {
    if(valueReceived != null) {
      setState(() {
        widget._messages.add(valueReceived);
      });
    }
  }
}

class ListaTransferenciaState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          })).then((transferenciaRecebida) => _atualiza(transferenciaRecebida));
        },
      ),
    );
    throw UnimplementedError();
  }

  void _atualiza(Transferencia? transferenciaRecebida) {
    if(transferenciaRecebida != null) {
      setState(() {
        widget._transferencias.add(transferenciaRecebida);
      });
    }
  }
}

class ItemList extends StatelessWidget {
  final String _message;

  ItemList(this._message);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(_message),
      ),
    );
    throw UnimplementedError();
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
    throw UnimplementedError();
  }
}