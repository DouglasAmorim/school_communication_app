import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_ifsc/models/CaixaEntradaAluno.dart';
import 'package:tcc_ifsc/models/Parents.dart';

import 'CaixaEntradaEscola.dart';
import 'CaixaEntradaPais.dart';
import 'CaixaEntradaProfessores.dart';
import 'Estudante.dart';
import 'Professor.dart';

class ApiImpl {

  // TODO: Mandar endpoints para um arquivo de constantes separados
  Future<Professor> teacherLogin(String username, String password) async {

    final response = await http.post(Uri.parse('http://localhost:5000/login/teacher/${username}/${password}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    print(response.statusCode);
    if(response.statusCode == 200) {
      print("200");
      return Professor.fromJson(jsonDecode(response.body));
    } else {
      print("another");
      throw Exception('Failed to load Professor');
    }
  }

  Future<Estudante> studentLogin(String username, String password) async {

    print(username);
    final response = await http.post(Uri.parse('http://localhost:5000/login/students/${username}/${password}'),
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

  Future<List<Professor>> alunosContacts(int id) async {
    final response = await http.get(Uri.parse('http://localhost:5000/alunos/${id}/contacts'),
      headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
     },
    );
    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<Professor> professorObj = listObj.map((json) => Professor.fromJson(json)).toList();
        return professorObj;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List<Parents>> teacherContactsParents(int id) async {
    final response = await http.get(Uri.parse('http://localhost:5000/professores/${id}/contacts/pais'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<Parents> parentsObj = listObj.map((json) => Parents.fromJson(json)).toList();
        print(parentsObj);
        return parentsObj;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List<Estudante>> teacherContactsAlunos(int id) async {
    final response = await http.get(Uri.parse('http://localhost:5000/professores/${id}/contacts/alunos'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<Estudante> estudanteObj = listObj.map((json) => Estudante.fromJson(json)).toList();
        return estudanteObj;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List<Professor>> parentsContacts(int id) async {
    final response = await http.get(Uri.parse('http://localhost:5000/pais/${id}/contacts'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    print(response.body);
    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<Professor> professorObj = listObj.map((json) => Professor.fromJson(json)).toList();
        return professorObj;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<bool> sendMessage(String url, int destinatarioId, int destinatarioQueueId, String remetenteNome, int remetenteId, String message) async {
    final response = await http.post(Uri.parse('${url}/${remetenteNome}/${destinatarioId}/${remetenteId}/${destinatarioQueueId}/${message}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<CaixaEntradaAluno>> getCaixaAlunos(String url) async {

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<CaixaEntradaAluno> obj = listObj.map((json) => CaixaEntradaAluno.fromJson(json)).toList();
        return obj;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load messages to alunos');
    }
  }

  Future<List<CaixaEntradaProfessores>> getCaixaProfessores(String url) async {

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<CaixaEntradaProfessores> obj = listObj.map((json) => CaixaEntradaProfessores.fromJson(json)).toList();
        return obj;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load messages to professores');
    }
  }

  Future<List<CaixaEntradaPais>> getCaixaPais(String url) async {

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<CaixaEntradaPais> obj = listObj.map((json) => CaixaEntradaPais.fromJson(json)).toList();
        return obj;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load messages to pais');
    }
  }

  Future<List<CaixaEntradaEscola>> getCaixaEscola(String url) async {

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if(response.statusCode == 200) {
      var listObj = jsonDecode(response.body) as List;
      if(listObj != null) {
        List<CaixaEntradaEscola> obj = listObj.map((json) => CaixaEntradaEscola.fromJson(json)).toList();
        return obj;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load messages to escolas');
    }
  }
}