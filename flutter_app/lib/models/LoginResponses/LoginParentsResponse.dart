import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/models/Users/Parents.dart';

class LoginParentsResponse {
  final Parents pais;
  final String access;
  final String refresh;

  const LoginParentsResponse({
    required this.pais,
    required this.access,
    required this.refresh,
  });

  factory LoginParentsResponse.fromJson(Map<String, dynamic> json) {
    final paisParse = Parents.fromJson(json['pais']);

    return LoginParentsResponse(
      pais: paisParse,
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}