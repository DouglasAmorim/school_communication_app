import 'package:tcc_ifsc/Enums/typeEnum.dart';
import 'package:tcc_ifsc/models/Users/Professor.dart';
import '../Users/Estudante.dart';

class LoginTeacherResponse {
  final Professor professor;
  final String access;
  final String refresh;

  const LoginTeacherResponse({
    required this.professor,
    required this.access,
    required this.refresh,
  });

  factory LoginTeacherResponse.fromJson(Map<String, dynamic> json) {
    final professorParse = Professor.fromJson(json['professor']);

    return LoginTeacherResponse(
      professor: professorParse,
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}