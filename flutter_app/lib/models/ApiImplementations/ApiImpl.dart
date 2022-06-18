import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcc_ifsc/Auth/secrets.dart';

class ApiImpl {
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
        "Sender-Name": "${message.senderName}",
        "Sender-Queue-Id": "${message.senderId}",
        "Sender-Type": "${message.senderType}",
        "Receiver-Queue-Id": "${message.receiverId}",
        "Receiver-Name": "${message.receiverName}",
        "Receiver-Type": "${message.receiverType}",
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