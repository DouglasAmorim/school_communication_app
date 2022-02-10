import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tcc_ifsc/components/Editor.dart';
import 'package:tcc_ifsc/models/ApiImpl.dart';
import 'package:tcc_ifsc/models/MqttClient.dart';
import 'package:tcc_ifsc/models/Transferencia.dart';

const _tituloAppBar = 'Criando Transferencia';
const _rotuloCampoValor = 'Valor' ;
const _dicaCampoValor = '0.00';
const _dicaCampoAccountNumber = '0001';
const _rotuloCampoAccountNumber = 'Numero da Conta';
const _textoBotaoConfirmar = 'Confirmar';

class SendMessage extends StatefulWidget {

  SendMessage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SendMessageState();
    throw UnimplementedError();
  }
}

class FormularioTransferencia extends StatefulWidget {

  FormularioTransferencia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();

    throw UnimplementedError();
  }
}

class SendMessageState extends State<SendMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _createMqtt(context),
              child: Text(_textoBotaoConfirmar),
            ),
          ],
        ),
      ),
    );
  }

  void _createMqtt(BuildContext context) {

    ApiImpl().login().then((value) {
      print(value);

      final client = new MqttServerClient.withPort('192.168.0.15', 'identifier' , 5672);

      final connMessage = MqttConnectMessage()
          .authenticateAs("admin", "D!o@4701298")
          .keepAliveFor(60)
          .withWillTopic('qwebapp')
          .withWillMessage('message')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      client.connectionMessage = connMessage;

      final MqttTest mqttTest = MqttTest(client);

      mqttTest.connect().then((value) {
        Navigator.pop(context, value);
      });
    });



  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controllerAccountNumber = TextEditingController();
  final TextEditingController _controllerValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(controller: _controllerAccountNumber, dica: _dicaCampoAccountNumber , rotulo: _rotuloCampoAccountNumber ),
            Editor(controller: _controllerValue, dica: _dicaCampoValor, rotulo: _rotuloCampoValor , iconData: Icons.monetization_on),
            ElevatedButton(
              onPressed: () => _transferencia(context),
              child: Text(_textoBotaoConfirmar),
            ),
          ],
        ),
      ),
    );
  }

  void _transferencia(BuildContext context) {
    final int? numberAccount = int.tryParse(_controllerAccountNumber.text);
    final double? value = double.tryParse(_controllerValue.text);

    final transferenciaCriada = Transferencia(value!,numberAccount!);
    debugPrint('$transferenciaCriada');
    Navigator.pop(context, transferenciaCriada);
  }
}