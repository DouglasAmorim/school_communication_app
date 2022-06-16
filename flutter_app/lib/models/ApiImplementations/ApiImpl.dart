import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_ifsc/models/CaixaEntradaResponses/CaixaEntradaAluno.dart';
import 'package:tcc_ifsc/models/EstruturaMensagem.dart';
import 'package:tcc_ifsc/models/LoginResponses/LoginParentsResponse.dart';
import 'package:tcc_ifsc/models/LoginResponses/LoginStudentResponse.dart';
import 'package:tcc_ifsc/models/LoginResponses/LoginTeacherResponse.dart';
import 'package:tcc_ifsc/models/Storage/SecureStorage.dart';
import 'package:tcc_ifsc/models/Users/Parents.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../CaixaEntradaResponses/CaixaEntradaEscola.dart';
import '../CaixaEntradaResponses/CaixaEntradaPais.dart';
import '../CaixaEntradaResponses/CaixaEntradaProfessores.dart';
import '../Users/Estudante.dart';
import '../Users/Professor.dart';
import 'package:tcc_ifsc/FcmMessaging/secrets.dart';

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

  Future<Professor> teacherLogin(String username, String password) async {

    final response = await http.post(Uri.parse('http://localhost:5000/login/teacher/${username}/${password}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200) {
      final parsedResponse = LoginTeacherResponse.fromJson(jsonDecode(response.body));

      print(parsedResponse.professor);
      // final keyAccessToken = "accessToken";
      // final keyRefreshToken = "refreshToken";

      final secureStorage = new SecureStorage();
      //
      // secureStorage.writeSecureData(keyAccessToken, parsedResponse.access);
      // secureStorage.writeSecureData(keyRefreshToken, parsedResponse.refresh);
      //
      secureStorage.setTokens(parsedResponse.access, parsedResponse.refresh);

      return parsedResponse.professor;
    } else {
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
      final parsedResponse = LoginStudentResponse.fromJson(jsonDecode(response.body));

      // final keyAccessToken = "accessToken";
      // final keyRefreshToken = "refreshToken";

      final secureStorage = new SecureStorage();
      //
      // secureStorage.writeSecureData(keyAccessToken, parsedResponse.access);
      // secureStorage.writeSecureData(keyRefreshToken, parsedResponse.refresh);

      secureStorage.setTokens(parsedResponse.access, parsedResponse.refresh);

      return parsedResponse.estudante;
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
      final parsedResponse = LoginParentsResponse.fromJson(jsonDecode(response.body));
      //
      // final keyAccessToken = "accessToken";
      // final keyRefreshToken = "refreshToken";

      final secureStorage = new SecureStorage();
      //
      // secureStorage.writeSecureData(keyAccessToken, parsedResponse.access);
      // secureStorage.writeSecureData(keyRefreshToken, parsedResponse.refresh);

      secureStorage.setTokens(parsedResponse.access, parsedResponse.refresh);

      return parsedResponse.pais;
    } else {
      throw Exception('Failed to load Professor');
    }
  }

  Future<List<Professor>> alunosContacts(int id) async {
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('http://localhost:5000/alunos/${id}/contacts'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('http://localhost:5000/professores/${id}/contacts/pais'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('http://localhost:5000/professores/${id}/contacts/alunos'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('http://localhost:5000/pais/${id}/contacts'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.post(Uri.parse('${url}/${remetenteNome}/${destinatarioId}/${remetenteId}/${destinatarioQueueId}/${message}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    final secureStorage = new SecureStorage();
    final token = secureStorage.getAccessToken();

    final response = await http.get(Uri.parse('${url}'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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