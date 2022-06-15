import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_ifsc/models/Cells/ContactItemCell.dart';

import '../../Helpers/Strings.dart';
import '../../models/ContactsItemList.dart';
import '../../models/EstruturaMensagem.dart';
import '../../models/Users/User.dart';
import '../FluxoLogin/Signup.dart';

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
  final List<ContactData> _contactsList = [];
  var _getContacts = true;

  ContactsList({Key? key, required this.user, this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    user.id = uid!;
    return _ContactsListState();
  }
}

class _ContactsListState extends State<ContactsList> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if(widget._getContacts) {
      _getUserInformation();
    }

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
                // TODO: Implementar get das mensagens

                final contact = widget._contactsList[indice];
                final List<EstruturaMensagem> lista = [];
                print("banana contact ${indice} ${contact.username} ${contact.name} ${contact.id}");

                return ContactItemCell(contact);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getUserInformation() {
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
    print("Banana get user contacts ${widget.user.id}");
    print("Banana get user contacts ${widget.user.turma}");
    print("Banana get user contacts ${widget.user.type}");

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

            setState(() {
              widget._contactsList.add(contact);
            });
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

                  print("banana data Type ${data["Type"]}");

                  contact.id = data[Strings.idFirestore];
                  contact.name = data[Strings.nameFirestore];
                  contact.username = data[Strings.usernameFirestore];
                  contact.type = data[Strings.typeFirestore];
                  contact.turma = data[Strings.turmaFirestore];

                  setState(() {
                    widget._contactsList.add(contact);
                  });
                }
              });
            });

        break;
      case "Student":
        firestoreInstance.collection("users")
            .where("Turma", isEqualTo: widget.user.turma)
            .get()
            .then((query) {
              print("banana query ${query}");

              query.docs.forEach((result) {
                print("banana query ${result.data()}");

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

                      setState(() {
                        widget._contactsList.add(contact);
                      });
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

                      setState(() {
                        widget._contactsList.add(contact);
                      });
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

                setState(() {
                  widget._contactsList.add(contact);
                });
              });
            });
        break;
      default:

        print("Banana get user contacts default case");
        firestoreInstance.collection("users")
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

            setState(() {
              widget._contactsList.add(contact);
            });
          });
        });
        break;
    }

    widget._getContacts = false;
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
