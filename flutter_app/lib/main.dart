import 'package:flutter/material.dart';
import 'package:tcc_ifsc/screens/Transferencia/Lista.dart';
import 'package:mqtt_client/mqtt_client.dart';

void main() {
  runApp(TccIfsc());
}

class TccIfsc extends StatelessWidget {
  const TccIfsc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: Colors.blueAccent[700],
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: MessageList(), //ListaTransferencias(),
    );
  }
}