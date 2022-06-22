

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/EstruturaNoticia.dart';

class Noticia extends StatefulWidget {
  final List<EstruturaNoticia> noticias;


  Noticia({Key? key, required this.noticias}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoticiaState();
  }
}

class NoticiaState extends State<Noticia> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Noticias"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.noticias.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, indice) {
                final noticia = widget.noticias[indice];
                Color color = Colors.white;

                return NoticiaItemList(noticia.message, noticia.titulo, color);
              },
            ),
          ],
        ),
      ),
    );
  }
}


class NoticiaItemList extends StatelessWidget {
  final String _noticia;
  final String? _titulo;
  final Color _color;

  NoticiaItemList(this._noticia, this._titulo, this._color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.newspaper),
        title: Text(_titulo ?? ""),
        subtitle: Text(_noticia),

      ),
      color: _color,
    );
  }
}