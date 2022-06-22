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
import 'package:tcc_ifsc/screens/Noticia/Noticia.dart';

import '../../Helpers/Strings.dart';
import '../../models/EstruturaMensagem.dart';
import '../../models/EstruturaNoticia.dart';
import '../../models/Users/User.dart';
import '../FluxoLogin/Signup.dart';
import '../Mensagem/Mensagem.dart';

Future<void> _messageHandler(RemoteMessage event) async {
  if(event.data["news"] == "true") {
    final noticiaRecebida = EstruturaNoticia(
        titulo: event.data['title'],
        message: event.data['message'],
        date: DateFormat('kk:mm:ss \n EEE d MMM yyyy').format(
            DateTime.now()),
        receiverId: event.data['Receiver-Queue-Id'],
        senderId: event.data['Sender-Queue-Id'],
        senderName: event.data['Sender-Name'],
        senderType: event.data['Sender-Type']);

    FileHandler.instance.writeNoticia(noticiaRecebida);

  } else {

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
  List<EstruturaNoticia> _noticiaList = [];

  var _getContacts = true;
  String idContactOpen = "";

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
    widget.idContactOpen = "";

    WidgetsBinding.instance.addObserver(this);
    messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_messageHandler);

    messaging.subscribeToTopic(widget.user.id);

    messaging.getToken().then((value) {
      print("User Token ${value}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("RECEBIDO ${event.data}");
      if (event.data["news"] == "true") {
        print("RECEBIDO NOTICIA");
        _tratarNoticiasRecebidas(event);
        return;
      }

      FileHandler.instance.readMessages().then((value) =>
      {
        setState(() {
          List<EstruturaMensagem> lista = [];
          for (int i = 0; i < value.length; i++) {
            if (value[i].receiverId == widget.user.id ||
                value[i].senderId == widget.user.id) {
              lista.add(value[i]);
            } else {
              if (value[i].receiverType == "Group") {
                for (int j = 0; j < widget.user.grupos.length; j++) {
                  if (value[i].receiverId == widget.user.grupos[j].queue) {
                    lista.add(value[i]);
                  }
                }
              }
            }
          }

          widget._messageList = lista;

          final messageReceived = EstruturaMensagem(
              message: event.data['message'],
              date: DateFormat('kk:mm:ss \n EEE d MMM yyyy').format(
                  DateTime.now()),
              receiverId: event.data['Receiver-Queue-Id'],
              receiverName: event.data['Receiver-Name'],
              receiverType: event.data['Receiver-Type'],
              senderId: event.data['Sender-Queue-Id'],
              senderName: event.data['Sender-Name'],
              senderType: event.data['Sender-Type']);

          if (messageReceived.senderId != widget.user.id) {
            FileHandler.instance.writeMessages(messageReceived);
            widget._messageList.add(messageReceived);
          }

          if (messageReceived.senderId == widget.idContactOpen &&
              messageReceived.receiverType != "Group") {
            Navigator.pop(context);
            for (int i = 0; i < widget._contactsList.length; i++) {
              if (widget._contactsList[i].id == messageReceived.senderId) {
                final List<EstruturaMensagem> lista = [];
                for (var j = 0; j < widget._messageList.length; j++) {
                  if (widget._messageList[j].receiverId ==
                      widget._contactsList[i].id ||
                      widget._messageList[j].senderId ==
                          widget._contactsList[i].id) {
                    lista.add(widget._messageList[j]);
                  }
                  widget._contactsList[i].messages = lista;
                  widget.idContactOpen = widget._contactsList[i].id;
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Mensagem(messages: widget._contactsList[i].messages,
                      receiverQueueId: widget._contactsList[i].id,
                      receiverName: widget._contactsList[i].name,
                      typeReceiver: widget._contactsList[i].type,
                      senderQueueId: widget.user.id,
                      senderName: widget.user.name,
                      typeSender: widget.user.type);
                })).then((value) =>
                {
                  widget.idContactOpen = "",
                });

                break;
              }
            }
          }
        }),
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final senderId = event.data['Sender-Queue-Id'];

      if(event.data["news"] == "true") {
        // TODO: Redirecionar tela noticia
        return;
      }

      FileHandler.instance.readMessages().then((value) =>
      {
        setState(() {
          List<EstruturaMensagem> lista = [];

          for (int i = 0; i < value.length; i++) {
            if (value[i].receiverId == widget.user.id ||
                value[i].senderId == widget.user.id) {
              lista.add(value[i]);
            } else {
              if (value[i].receiverType == "Group") {
                for (int j = 0; j < widget.user.grupos.length; j++) {
                  if (value[i].receiverId == widget.user.grupos[j].queue) {
                    lista.add(value[i]);
                  }
                }
              }
            }
          }

          widget._messageList = lista;

          for (int i = 0; i < widget._contactsList.length; i++) {
            if (widget._contactsList[i].id == senderId &&
                event.data["Receiver-Type"] != "Group") {
              final List<EstruturaMensagem> lista = [];

              for (var j = 0; j < widget._messageList.length; j++) {
                if (widget._messageList[j].receiverId ==
                    widget._contactsList[i].id
                    || widget._messageList[j].senderId ==
                        widget._contactsList[i].id) {
                  lista.add(widget._messageList[j]);
                }
              }

              widget._contactsList[i].messages = lista;
              print("Banana contact ${widget._contactsList[i].id}");
              widget.idContactOpen = widget._contactsList[i].id;

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Mensagem(messages: widget._contactsList[i].messages,
                    receiverQueueId: widget._contactsList[i].id,
                    receiverName: widget._contactsList[i].name,
                    typeReceiver: widget._contactsList[i].type,
                    senderQueueId: widget.user.id,
                    senderName: widget.user.name,
                    typeSender: widget.user.type);
              })).then((value) =>
              {
                widget.idContactOpen = "",
              });
            }
          }
        }),
      });
    });

    if (widget._getContacts) {
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
                if (widget.user.valid != "True") {
                  final contact = widget._contactsList[indice];
                  final List<EstruturaMensagem> lista = [];

                  for (var i = 0; i < widget._messageList.length; i++) {
                    if(widget._messageList[i].receiverType == "Group") {
                      if(widget._messageList[i].receiverId == contact.id) {
                        lista.add(widget._messageList[i]);
                      }
                    } else {
                      if(widget._messageList[i].receiverId == contact.id
                          || widget._messageList[i].senderId == contact.id)  {
                        lista.add(widget._messageList[i]);
                      }
                    }
                  }

                  contact.messages = lista;

                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.school),
                      title: Text("Entre em contato com a Instituição de Ensino \nPara que seja finalizado seu cadastro."),
                      onTap: () {
                        widget.idContactOpen = contact.id;

                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Mensagem(messages: contact.messages,
                              receiverQueueId: contact.id,
                              receiverName: contact.name,
                              typeReceiver: contact.type,
                              senderQueueId: widget.user.id,
                              senderName: widget.user.name,
                              typeSender: widget.user.type);
                        })).then((value) => {
                          widget.idContactOpen = "",
                        });
                      },
                    ),
                  );
                } else {
                  final contact = widget._contactsList[indice];
                  final List<EstruturaMensagem> lista = [];


                  for (var i = 0; i < widget._messageList.length; i++) {
                    if(widget._messageList[i].receiverType == "Group") {
                      if(widget._messageList[i].receiverId == contact.id) {
                        lista.add(widget._messageList[i]);
                      }
                    } else {
                      if(widget._messageList[i].receiverId == contact.id
                          || widget._messageList[i].senderId == contact.id)  {
                        lista.add(widget._messageList[i]);
                      }
                    }
                  }

                  contact.messages = lista;

                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.message),
                      title: Text(contact.name),
                      onTap: () {
                        widget.idContactOpen = contact.id;
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Mensagem(messages: contact.messages,
                              receiverQueueId: contact.id,
                              receiverName: contact.name,
                              typeReceiver:contact.type,
                              senderQueueId: widget.user.id,
                              senderName: widget.user.name,
                              typeSender: widget.user.type);
                        })).then((value) => {
                          widget.idContactOpen = "",
                        });
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _tratarNoticiasRecebidas(RemoteMessage event) {
    print("BANANA tratar noticia recebida");

    final noticiaRecebida = EstruturaNoticia(
        titulo: event.data['title'],
        message: event.data['message'],
        date: DateFormat('kk:mm:ss \n EEE d MMM yyyy').format(
            DateTime.now()),
        receiverId: event.data['Receiver-Queue-Id'],
        senderId: event.data['Sender-Queue-Id'],
        senderName: event.data['Sender-Name'],
        senderType: event.data['Sender-Type']);

    setState(() {
      FileHandler.instance.writeNoticia(noticiaRecebida);
      widget._noticiaList.add(noticiaRecebida);
    });
  }

  void _getUserMessages() {
    FileHandler.instance.readMessages().then((value) => {
      setState(() {
        List<EstruturaMensagem> lista = [];

        for(int i = 0; i < value.length; i++) {
          if(value[i].receiverId == widget.user.id || value[i].senderId == widget.user.id) {
            lista.add(value[i]);
          } else {
            if(value[i].receiverType == "Group") {
              for(int j = 0; j < widget.user.grupos.length; j++) {
                if(value[i].receiverId == widget.user.grupos[j].queue) {
                  lista.add(value[i]);
                }
              }
            }
          }
        }
        widget._messageList = lista;
      }),
    });

    FileHandler.instance.readNoticia().then((value) => {
      setState( () {
        List<EstruturaNoticia> lista = [];
        for(int i = 0; i < value.length; i++) {
          lista.add(value[i]);
        }

        widget._noticiaList = lista;
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

          List.from(data[Strings.turmaFirestore]).forEach((element) {
            String turma = element.toString();
            widget.user.turma.add(turma);
          });

          widget.user.valid = data[Strings.validFirestore];
        });

        _getUserContacts();
    });
  }

  Future<void> _listenNewsTopic() async {
    switch(widget.user.type) {
      case "Student":
        print("BANANA escutando ao grupo ${widget.user.turma[0]}");
        await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasTurmaAlunos${widget.user.turma[0]}");

        print("topicTurma${widget.user.turma[0]}");
        await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasTurma${widget.user.turma[0]}");

        print("topicTurma${widget.user.turma[0]}");
        await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasEscola");

        break;
      case "Parensts":

        for(int i = 0; i < widget.user.turma.length; i++) {
          print("topicTurma${widget.user.turma[i]}");
          await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasTurma${widget.user.turma[i]}");

          print("topicNoticiasPaisTurma${widget.user.turma[i]}");
          await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasPaisTurma${widget.user.turma[i]}");
        }

        print("topicTurma${widget.user.turma[0]}");
        await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasEscola");

        break;
      default:
        for(int i = 0; i < widget.user.turma.length; i++) {
          print("topicTurma${widget.user.turma[i]}");
          await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasTurma${widget.user.turma[i]}");
        }

        print("topicTurma${widget.user.turma[0]}");
        await FirebaseMessaging.instance.subscribeToTopic("topicNoticiasEscola");
        break;
    }
  }

  Future<void> _listenTopicGroup() async {
    for(int i = 0; i < widget.user.grupos.length; i++) {
      print("BANANA escutando ao grupo ${widget.user.grupos[i].queue}");
      await FirebaseMessaging.instance.subscribeToTopic(widget.user.grupos[i].queue);
    }

    _listenNewsTopic();
  }

  void _getGroups() {
    print("Banana starting get groups");
    switch(widget.user.type){
      case "Student":
        print("BANANA user is student");

        firestoreInstance.collection("grupos")
            .get()
            .then((query) {
          print("Banana query ${query}");
          query.docs.forEach((result) {
            print("Banana result ${result}");
            final data = result.data();
            print("Banana ${data}");

            for(int i = 0; i < widget.user.turma.length; i++) {
              if(data["Turma"].contains(widget.user.turma[i]) && data["TipoGrupo"].contains(widget.user.type)) {
                print("Banana group student contain turma");

                Grupos grupo = Grupos();
                grupo.nome = data["Nome"];
                grupo.queue = data["Queue"];

                List.from(data["Turma"]).forEach((element) {
                  String turma = element.toString();
                  grupo.turma.add(turma);
                });

                List.from(data["TipoGrupo"]).forEach((element) {
                  String tipoGrupo = element.toString();
                  grupo.tipoGrupo.add(tipoGrupo);
                });

                if(widget.user.grupos.contains(grupo) == false ) {
                  setState(() {
                    widget.user.grupos.add(grupo);
                  });
                }

                ContactData contact = ContactData();
                contact.name = grupo.nome;
                contact.turma = grupo.turma;
                contact.id = grupo.queue;
                contact.type = "Group";
                contact.username = grupo.nome;


                if(widget._contactsList.contains(contact) == false ) {
                  setState(() {
                    widget._contactsList.add(contact);
                  });
                }
              }
            }
          });
          _listenTopicGroup();
          _getUserMessages();
        });
        break;
      case "Parents":
        print("BANANA user is parents");
        firestoreInstance.collection("grupos")
            .get()
            .then((query) {

          query.docs.forEach((result) {
            final data = result.data();

            for(int i = 0; i < widget.user.turma.length; i++){
              if(data["TipoGrupos"].contains(widget.user.turma[i]) && data["TipoGrupo"].contains(widget.user.type) ) {
                print("Banana group student contain turma");

                Grupos grupo = Grupos();
                grupo.nome = data["Nome"];
                grupo.queue = data["Queue"];

                List.from(data["Turma"]).forEach((element) {
                  String turma = element.toString();
                  grupo.turma.add(turma);
                });

                List.from(data["TipoGrupo"]).forEach((element) {
                  String tipoGrupo = element.toString();
                  grupo.tipoGrupo.add(tipoGrupo);
                });

                if(widget.user.grupos.contains(grupo) == false ) {
                  setState(() {
                    widget.user.grupos.add(grupo);
                  });
                }

                ContactData contact = ContactData();
                contact.name = grupo.nome;
                contact.turma = grupo.turma;
                contact.id = grupo.queue;
                contact.type = "Group";
                contact.username = grupo.nome;


                if(widget._contactsList.contains(contact) == false ) {
                  setState(() {
                    widget._contactsList.add(contact);
                  });
                }
              }
            }
          });
          _listenTopicGroup();
          _getUserMessages();
        });
        break;
      default:
        print("BANANA user is default");
        firestoreInstance.collection("grupos")
            .get()
            .then((query) {

          query.docs.forEach((result) {
            final data = result.data();

            for(int i = 0; i < widget.user.turma.length; i++){
              if(data["TipoGrupos"].contains(widget.user.turma[i])) {
                print("Banana group student contain turma");

                Grupos grupo = Grupos();
                grupo.nome = data["Nome"];
                grupo.queue = data["Queue"];

                List.from(data["Turma"]).forEach((element) {
                  String turma = element.toString();
                  grupo.turma.add(turma);
                });

                List.from(data["TipoGrupo"]).forEach((element) {
                  String tipoGrupo = element.toString();
                  grupo.tipoGrupo.add(tipoGrupo);
                });

                if(widget.user.grupos.contains(grupo) == false ) {
                  setState(() {
                    widget.user.grupos.add(grupo);
                  });
                }

                ContactData contact = ContactData();
                contact.name = grupo.nome;
                contact.turma = grupo.turma;
                contact.id = grupo.queue;
                contact.type = "Group";
                contact.username = grupo.nome;


                if(widget._contactsList.contains(contact) == false ) {
                  setState(() {
                    widget._contactsList.add(contact);
                  });
                }

              }
            }
          });
          _listenTopicGroup();
          _getUserMessages();
        });
    }
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

            List.from(data[Strings.turmaFirestore]).forEach((element) {
              String turma = element.toString();
              contact.turma.add(turma);
            });

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
            .where("id", isNotEqualTo: widget.user.id)
            .get()
            .then((query) {
              query.docs.forEach((result) {
                final data = result.data();
                final contact = ContactData();

                for(int i = 0; i < widget.user.turma.length; i++){
                  if(data[Strings.turmaFirestore].contains(widget.user.turma[i])){

                    contact.id = data[Strings.idFirestore];
                    contact.name = data[Strings.nameFirestore];
                    contact.username = data[Strings.usernameFirestore];
                    contact.type = data[Strings.typeFirestore];

                    List.from(data[Strings.turmaFirestore]).forEach((element) {
                      String turma = element.toString();
                      contact.turma.add(turma);
                    });

                    if(widget._contactsList.contains(contact) == false ) {
                      setState(() {
                        widget._contactsList.add(contact);
                      });
                    }
                  }
                }
              });
            });

        break;
      case "Student":
        firestoreInstance.collection("users")
            .where("id", isNotEqualTo: widget.user.id)
            .get()
            .then((query) {

              query.docs.forEach((result) {

                final data = result.data();
                final contact = ContactData();

                print("BANANA adicionando contato ${data}");

                if(data[Strings.typeFirestore] != "Student" && data[Strings.typeFirestore] != "Parents")  {
                  for(int i = 0; i < widget.user.turma.length; i++) {

                    if(data[Strings.turmaFirestore].contains(widget.user.turma[i])){
                      contact.id = data[Strings.idFirestore];
                      contact.name = data[Strings.nameFirestore];
                      contact.username = data[Strings.usernameFirestore];
                      contact.type = data[Strings.typeFirestore];

                      List.from(data[Strings.turmaFirestore]).forEach((element) {
                        String turma = element.toString();
                        contact.turma.add(turma);
                      });

                      if(widget._contactsList.contains(contact) == false) {
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
            .where("id", isNotEqualTo: widget.user.id)
            .get()
            .then((query) {
              query.docs.forEach((result) {
                final data = result.data();
                final contact = ContactData();

                if(data[Strings.typeFirestore] != widget.user.type && data[Strings.typeFirestore] != "Students") {
                  for(int i = 0; i < widget.user.turma.length; i++) {
                    if(data[Strings.turmaFirestore].contains(widget.user.turma[i])) {
                      contact.id = data[Strings.idFirestore];
                      contact.name = data[Strings.nameFirestore];
                      contact.username = data[Strings.usernameFirestore];
                      contact.type = data[Strings.typeFirestore];
                      List.from(data[Strings.turmaFirestore]).forEach((element) {
                        String turma = element.toString();
                        contact.turma.add(turma);
                      });

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

                for(int i = 0; i < widget.user.turma.length; i++) {
                  if(data[Strings.turmaFirestore].contains(widget.user.turma[i])){
                    contact.id = data[Strings.idFirestore];
                    contact.name = data[Strings.nameFirestore];
                    contact.username = data[Strings.usernameFirestore];
                    contact.type = data[Strings.typeFirestore];

                    List.from(data[Strings.turmaFirestore]).forEach((element) {
                      String turma = element.toString();
                      contact.turma.add(turma);
                    });

                    if(widget._contactsList.contains(contact) == false ) {
                      setState(() {
                        widget._contactsList.add(contact);
                      });
                    }
                  }
                }
              });
            });
        break;
      default:
        // TODO: This type school will change to Resgistro academico
        firestoreInstance.collection("users")
            .where("Type", isEqualTo: "School")
            .get().then((query) {
              query.docs.forEach((result) {
                final data = result.data();
                final contact = ContactData();

                contact.id = data[Strings.idFirestore];
                contact.name = data[Strings.nameFirestore];
                contact.username = data[Strings.usernameFirestore];
                contact.type = data[Strings.typeFirestore];

                List.from(data[Strings.turmaFirestore]).forEach((element) {
                  String turma = element.toString();
                  contact.turma.add(turma);
                });

                if(widget._contactsList.contains(contact) == false ) {
                  setState(() {
                    widget._contactsList.add(contact);
                  });
                }
              });
          });
          break;
    }
    _getGroups();
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
              );
            },
          ),

          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.newspaper , color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Noticias'),
            onTap: () {
              FileHandler.instance.readNoticia().then((value) => {
                setState( () {
                  print("NOTICIA ${value} ${value.length}");

                  if(!value.isEmpty){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Noticia(noticias: value)),
                    );
                  } else {
                    //TODO: Informar ao usuario que está sem noticias
                  }

                }),
              });
            },
          ),
        ],
      ),
    );
  }
}
