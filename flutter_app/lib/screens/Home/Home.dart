import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_ifsc/models/Cells/ContactItemCell.dart';

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
  final List<UserData> _contactsList = [];
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

                return ContactItemCell(contact);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getUserInformation() {
    print("Banana get user information ${widget.user.id}");
    firestoreInstance.collection("users")
      .where("id", isEqualTo: widget.user.id)
      .get()
      .then((query) {
        query.docs.forEach((result) {

          final data = result.data();
          widget.user.id = data["id"];
          widget.user.name = data["name"];
          widget.user.matricula = data["matricula"];
          widget.user.username = data["username"];
          widget.user.type = data["type"];
          widget.user.turma = data["Turma"];
        });
    });
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
