import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcc_ifsc/Auth/secrets.dart';
import 'package:tcc_ifsc/models/EstruturaNoticia.dart';

import '../../Helpers/Strings.dart';

class ApiImpl {

  Future<String> sendNoticia(EstruturaNoticia noticia) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    String toParams = "/topics/"+'${noticia.receiverId}';

    final data = {
      "notification": {
        "body": noticia.message,
        "title": noticia.titulo
      },
      "priority":"high",

      "data": {
        Strings.fcmSenderName: "${noticia.senderName}",
        Strings.fcmSenderQueueId: "${noticia.senderId}",
        Strings.fcmSenderType: "${noticia.senderType}",
        Strings.fcmReceiverQueueId: "${noticia.receiverId}",
        Strings.fcmNews: "true",
        "title": "${noticia.titulo}",
        "message": "${noticia.message}",
        "sendDate": "${noticia.date}",
      },

      "to": "${toParams}"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=${secretApiMessaging}'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      return(response.body);
    } else {
      throw Exception('Failed to send Message');
    }
  }

  Future<String> sendNotification(EstruturaMensagem message) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    String toParams = "/topics/"+'${message.receiverId}';

    final data = {
      "notification": {
        "body": message.message,
        "title": message.message
      },
      "priority":"high",

      "data": {
        Strings.fcmSenderName: "${message.senderName}",
        Strings.fcmSenderQueueId: "${message.senderId}",
        Strings.fcmSenderType: "${message.senderType}",
        Strings.fcmReceiverQueueId: "${message.receiverId}",
        Strings.fcmReceiverName: "${message.receiverName}",
        Strings.fcmReceiverType: "${message.receiverType}",
        "message": "${message.message}",
        "sendDate": "${message.date}",
      },

      "to": "${toParams}"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=${secretApiMessaging}'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      return(response.body);
    } else {
      throw Exception('Failed to send Message');
    }
  }
}