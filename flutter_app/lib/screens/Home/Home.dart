import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        body: ContactsList(),

        drawer: NavigateDrawer(uid: this.uid));
  }
}

class ContactsList extends StatefulWidget {
  final User user;
  final List<User> _contactsList = [];
  var _getContacts = true;

  ContactsList({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
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


  }



  void _getUserInformation() {
    firestoreInstance.collection("users")
      .where("id", isEqualTo: widget.uid)
      .get()
      .then((query) {
        query.docs.forEach((result) {
          print(result.data());
        });
    });
  }
}









class NavigateDrawer extends StatefulWidget {
  final String? uid;

  NavigateDrawer({Key? key, this.uid}) : super(key: key);

  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(

            // TODO: Get Account information From FirebaseFirestorm
              accountName: Text("TESTE"),
              accountEmail: Text("TESTE"),
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
