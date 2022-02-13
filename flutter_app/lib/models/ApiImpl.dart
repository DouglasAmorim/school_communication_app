import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Professor {
  final int id;
  final int queueId;
  final String name;
  final String password;

  const Professor({
    required this.id,
    required this.queueId,
    required this.name,
    required this.password,
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
        id: json['ProfessoresId'],
        queueId: json['QueueId'],
        name: json['Nome'],
        password: json['Senha'],
    );
  }
}

class ApiImpl {
  Future<Professor> login() async {

    print("NAMAA");

    final response = await http.post(Uri.parse('http://localhost:5000/login/Rubem/123456'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    /*headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
    'title': 'a',
    }),*/


    if(response.statusCode == 200) {
      return Professor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Professor');
    }


  }
}