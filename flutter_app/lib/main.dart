import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tcc_ifsc/screens/Login/Login.dart';
import 'Enums/SelectedLoginEnum.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<void> sendNotification(subject, title, senderName, senderQueueId, recipientQueueId) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';

  String toParams = "/topics/"+'${recipientQueueId}';

  final data = {
    "notification": {
      "body": subject,
      "title":title
    },
    "priority":"high",
    "data": {
      "Name": "${senderName}",
      "Sender-Queue-Id": "${senderQueueId}",
    },
    "to": "${toParams}"
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=key'
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    print("true ${response.body}");
  } else {
    print("false");
  }
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
  final firestoresInstance = FirebaseFirestore.instance;

  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // messaging.subscribeToTopic("destinoQueue");

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
              _onpressed(),
                // _openLoginScreen(context, SelectedLoginUser.school),
            child: const Text('Escola'),
          ),

        ],
      ),
    );
  }

  void _onpressed() {
    firestoresInstance.collection("users").add(
        {
          "name": "Cleiton Rasta",
          "username": "cleitonRasta",
          "Type": "Teacher",
          "queueId": "teacher_cleiton"
        }
    ).then((value) {
      print(value.id);
    });

    firestoresInstance.collection("users").add({
    "name": "Cleiton Bob",
    "username": "cleitonBob",
    "Type": "Student",
    "queueId": "student_cleiton"
    }).then((value) {
    print(value.id);
    });
  }


  void _openLoginScreen(BuildContext context, SelectedLoginUser loginUser) {
    // print("chamou aqui");
    // sendNotification("banana", "pijama", "meuNome", "minhaQueue", "destinoQueue");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login(loginUser: loginUser,);
    }));
  }
}