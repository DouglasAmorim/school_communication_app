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
      home: Scaffold(
        appBar: AppBar(title: const Text('TCC App')),
        body: const LoginWidget(),
      ), // MessageList(), //ListaTransferencias(),
    );
  }
}


class LoginWidget extends StatefulWidget {
  const LoginWidget({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {

    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: Colors.green,
        minimumSize: const Size.fromHeight(50)
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          ElevatedButton(style: style,
              onPressed: null,
              child: const Text('STUDENT_LOGIN'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: null,
            child: const Text('TEACHER_LOGIN'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: null,
            child: const Text('PARENTS_LOGIN'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: null,
            child: const Text('SCHOOL_LOGIN'),
          ),

        ],
      ),
    );

    // TODO: implement build
    throw UnimplementedError();
  }

}
