import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiImpl {
  Future<String> login() async {
    final response = await http.post(Uri.parse('http://localhost:5000/login/Rubem/123456'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': 'a',
      }),
    );

    print(response);

    if(response.statusCode == 200) {
      return "BANANA";
    } else {
      throw Exception("ERROR ON CALL API");
    }
  }
}