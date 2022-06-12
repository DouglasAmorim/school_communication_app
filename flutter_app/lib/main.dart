import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tcc_ifsc/screens/Login/Login.dart';
import 'Enums/SelectedLoginEnum.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
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
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {

  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    messaging.subscribeToTopic('messaging');

    messaging.getToken().then((value) {
      print("token ${value}");
      // print(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message received");
      print(event.notification!.body);
      print(event.data.values);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Notification'),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok')
                )
              ],

            );
          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message clicked!");
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        primary: Colors.green,
        minimumSize: const Size.fromHeight(50)
    );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ElevatedButton(style: style,
            onPressed: () =>
                _openLoginScreen(context, SelectedLoginUser.student),
            child: const Text('Estudantes'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: () =>
                _openLoginScreen(context, SelectedLoginUser.teacher),
            child: const Text('Professores'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: () =>
                _openLoginScreen(context, SelectedLoginUser.parents),
            child: const Text('Pais'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(style: style,
            onPressed: () =>
                _openLoginScreen(context, SelectedLoginUser.school),
            child: const Text('Escola'),
          ),

        ],
      ),
    );
  }

  void _openLoginScreen(BuildContext context, SelectedLoginUser loginUser) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login(loginUser: loginUser,);
    }));
  }
}