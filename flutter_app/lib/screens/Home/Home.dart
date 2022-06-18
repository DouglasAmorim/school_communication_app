import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tcc_ifsc/models/Cells/ContactItemCell.dart';
import 'package:tcc_ifsc/models/Storage/FileHandler.dart';
import 'package:intl/intl.dart';

import '../../Helpers/Strings.dart';
import '../../models/ContactsItemList.dart';
import '../../models/EstruturaMensagem.dart';
import '../../models/Users/User.dart';
import '../FluxoLogin/Signup.dart';

Future<void> _messageHandler(RemoteMessage event) async {
  final messageReceived = EstruturaMensagem(
      message: event.data['message'],
      date: DateFormat('kk:mm:ss \n EEE d MMM yyyy').format(DateTime.now()) ,
      receiverId: event.data['Receiver-Queue-Id'],
      receiverName: event.data['Receiver-Name'],
      receiverType: event.data['Receiver-Type'],
      senderId: event.data['Sender-Queue-Id'],
      senderName: event.data['Sender-Name'],
      senderType: event.data['Sender-Type']
  );

  FileHandler.instance.writeMessages(messageReceived);
}

class Home extends StatelessWidget {
  Home({this.uid});
  final String? uid;
  final String? title = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title!),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                          (Route<dynamic> route) => false);
                });
              },
            )
          ],
        ),
        body: ContactsList(user: UserData(), uid: this.uid,),

        drawer: NavigateDrawer(user: UserData(), uid: this.uid));
  }
}

class ContactsList extends StatefulWidget {
  final UserData user;
  final String? uid;
  List<ContactData> _contactsList = [];
  List<EstruturaMensagem> _messageList = [];
  var _getContacts = true;

  ContactsList({Key? key, required this.user, this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    user.id = uid!;
    return _ContactsListState();
  }
}

class _ContactsListState extends State<ContactsList> with WidgetsBindingObserver {
  final firestoreInstance = FirebaseFirestore.instance;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_messageHandler);

    messaging.subscribeToTopic(widget.user.id);

    messaging.getToken().then((value) {
      print("User Token ${value}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {

      final messageReceived = EstruturaMensagem(
        message: event.data['message'],
        date: DateFormat('kk:mm:ss \n EEE d MMM yyyy').format(DateTime.now()),
        receiverId: event.data['Receiver-Queue-Id'],
        receiverName: event.data['Receiver-Name'],
        receiverType: event.data['Receiver-Type'],
        senderId: event.data['Sender-Queue-Id'],
        senderName: event.data['Sender-Name'],
        senderType: event.data['Sender-Type']
      );

      FileHandler.instance.writeMessages(messageReceived);
      setState(() {
        widget._messageList.add(messageReceived);
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // TODO: Redirecionar para Tela do contato da mensagem
    });

    if(widget._getContacts) {
      _getUserInformation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });

    if(state == AppLifecycleState.resumed) {
      _getUserMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Students List
            ListView.builder(
              itemCount: widget._contactsList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,

              itemBuilder: (context, indice) {
                final contact = widget._contactsList[indice];
                final List<EstruturaMensagem> lista = [];

                for (var i = 0; i < widget._messageList.length; i++) {
                  if(widget._messageList[i].receiverId == contact.id
                      || widget._messageList[i].senderId == contact.id)  {
                    lista.add(widget._messageList[i]);
                  }
                }

                contact.messages = lista;

                return ContactItemCell(contact, widget.user);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getUserMessages() {
    FileHandler.instance.readMessages().then((value) => {
      setState(() {
        List<EstruturaMensagem> lista = [];

        for(int i = 0; i < value.length; i++) {
          if(value[i].receiverId == widget.user.id || value[i].senderId == widget.user.id) {
            lista.add(value[i]);
          }
        }
        widget._messageList = lista;
      }),
    });
  }

  void _getUserInformation() {
    widget._getContacts = false;
    firestoreInstance.collection("users")
      .where("id", isEqualTo: widget.user.id)
      .get()
      .then((query) {
        query.docs.forEach((result) {

          final data = result.data();

          widget.user.id = data[Strings.idFirestore];
          widget.user.name = data[Strings.nameFirestore];
          widget.user.matricula = data[Strings.matriculaFirestore];
          widget.user.username = data[Strings.usernameFirestore];
          widget.user.type = data[Strings.typeFirestore];
          widget.user.turma = data[Strings.turmaFirestore];
        });

        _getUserContacts();
    });
  }


  void _getUserContacts() {
    widget._contactsList = [];

    switch(widget.user.type) {
      case "Adm":
        firestoreInstance.collection("users")
            .where("id", isNotEqualTo: widget.user.id)
            .get()
            .then((query) {
          query.docs.forEach((result) {
            final data = result.data();
            final contact = ContactData();

            contact.id = data[Strings.idFirestore];
            contact.name = data[Strings.nameFirestore];
            contact.username = data[Strings.usernameFirestore];
            contact.type = data[Strings.typeFirestore];
            contact.turma = data[Strings.turmaFirestore];

            if(widget._contactsList.contains(contact) == false ) {
              setState(() {
                widget._contactsList.add(contact);
              });
            }
          });
        });
        break;
      case "Teacher":
        firestoreInstance.collection("users")
            .where("Turma", isEqualTo: widget.user.turma)
            .get()
            .then((query) {
              query.docs.forEach((result) {
                final data = result.data();
                final contact = ContactData();

                if(data["Type"] != widget.user.type) {

                  contact.id = data[Strings.idFirestore];
                  contact.name = data[Strings.nameFirestore];
                  contact.username = data[Strings.usernameFirestore];
                  contact.type = data[Strings.typeFirestore];
                  contact.turma = data[Strings.turmaFirestore];

                  if(widget._contactsList.contains(contact) == false ) {
                    setState(() {
                      widget._contactsList.add(contact);
                    });
                  }
                }
              });
            });

        break;
      case "Student":
        firestoreInstance.collection("users")
            .where("Turma", isEqualTo: widget.user.turma)
            .get()
            .then((query) {

              query.docs.forEach((result) {

                final data = result.data();
                final contact = ContactData();

                if(data["Type"] != "Student")  {
                  if(data["Type"] != "Adm") {
                    if(data["Type"] != "Parents") {

                      contact.id = data[Strings.idFirestore];
                      contact.name = data[Strings.nameFirestore];
                      contact.username = data[Strings.usernameFirestore];
                      contact.type = data[Strings.typeFirestore];
                      contact.turma = data[Strings.turmaFirestore];

                      if(widget._contactsList.contains(contact) == false ) {
                        setState(() {
                          widget._contactsList.add(contact);
                        });
                      }
                    }
                  }
                }
              });
            });
        break;
      case "Parents":
        firestoreInstance.collection("users")
            .where("Turma", isEqualTo: widget.user.turma)
            .get()
            .then((query) {
              query.docs.forEach((result) {
                final data = result.data();
                final contact = ContactData();
                if(data["Type"] != widget.user.type) {
                  if (data["Type"] != "Adm") {
                    if (data["Type"] != "Students") {

                      contact.id = data[Strings.idFirestore];
                      contact.name = data[Strings.nameFirestore];
                      contact.username = data[Strings.usernameFirestore];
                      contact.type = data[Strings.typeFirestore];
                      contact.turma = data[Strings.turmaFirestore];

                      if(widget._contactsList.contains(contact) == false ) {
                        setState(() {
                          widget._contactsList.add(contact);
                        });
                      }
                    }
                  }
                }
              });
            });
        break;
      case "School":
        firestoreInstance.collection("users")
            .where("id", isNotEqualTo: widget.user.id)
            .get()
            .then((query) {
              query.docs.forEach((result) {
                final data = result.data();
                final contact = ContactData();

                contact.id = data[Strings.idFirestore];
                contact.name = data[Strings.nameFirestore];
                contact.username = data[Strings.usernameFirestore];
                contact.type = data[Strings.typeFirestore];
                contact.turma = data[Strings.turmaFirestore];

                if(widget._contactsList.contains(contact) == false ) {
                  setState(() {
                    widget._contactsList.add(contact);
                  });
                }
              });
            });
        break;
      default:
        // TODO: User não possui Type
        break;
    }
    _getUserMessages();
  }
}

class NavigateDrawer extends StatefulWidget {
  final String? uid;
  final UserData user;

  NavigateDrawer({Key? key, required this.user, this.uid}) : super(key: key);

  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(

              accountName: Text(widget.user.name),
              accountEmail: Text(widget.user.username),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
          ),

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.home, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Home'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
              );
            },
          ),

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.settings, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Settings'),
            onTap: () {
              print(widget.uid);
            },
          ),
        ],
      ),
    );
  }
}
