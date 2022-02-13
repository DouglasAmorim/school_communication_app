import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_ifsc/models/Parents.dart';

import 'Estudante.dart';
import 'Professor.dart';

class ApiImpl {

  Future<Professor> teacherLogin(String username, String password) async {

    final response = await http.post(Uri.parse('http://localhost:5000/login/teacher/${username}/${password}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      return Professor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Professor');
    }
  }

  Future<Estudante> studentLogin(String username, String password) async {

    print(username);
    final response = await http.post(Uri.parse('http://localhost:5000/login/student/${username}/${password}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      return Estudante.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Professor');
    }
  }

  Future<Parents> parentsLogin(String username, String password) async {

    final response = await http.post(Uri.parse('http://localhost:5000/login/parents/${username}/${password}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      return Parents.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Professor');
    }
  }
}