import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_ifsc/models/EstruturaGrupoNoticia.dart';
import 'package:tcc_ifsc/models/EstruturaNoticia.dart';
import 'package:intl/intl.dart';
import '../../models/ApiImplementations/ApiImpl.dart';
import '../../models/Users/User.dart';

class EnviarNoticia extends StatefulWidget {
  UserData user;
  String grupo;

  EnviarNoticia({Key? key, required this.user, required this.grupo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EnviarNoticiaState();
  }
}

class EnviarNoticiaState extends State<EnviarNoticia> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController noticiaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Criar Usuário")),
        body: Form(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: tituloController,
                      decoration: InputDecoration(
                        labelText: "Titulo da Noticia",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre Com o Titulo';
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: noticiaController,
                      decoration: InputDecoration(
                        labelText: "Noticia...",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Digite uma noticia';
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue)),
                      onPressed: () {
                        enviarNoticia(context);
                      },
                      child: Text('Enviar Noticia'),
                    ),
                  )

                ])
            )
        )
    );
  }


  void enviarNoticia(BuildContext context) {
    final String? noticia = noticiaController.text;
    final String? titulo = tituloController.text;

    if(noticia != null) {
      final EstruturaNoticia msg = EstruturaNoticia(
          titulo: titulo!,
          message: noticia,
          date: DateFormat('kk:mm:ss \n EEE d MMM yyyy').format(DateTime.now()),
          receiverId: widget.grupo,
          senderId: widget.user.id,
          senderName: widget.user.name,
          senderType: widget.user.type);

      print("BANANA escrevendo noticia ${msg}");
      ApiImpl().sendNoticia(msg).then((value) => {
        // TODO: FEEDBACK de noticia enviada com sucesso
        Navigator.pop(context),
      });
    }
  }
}
