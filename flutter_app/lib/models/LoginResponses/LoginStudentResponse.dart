import 'package:tcc_ifsc/Enums/typeEnum.dart';
import '../Users/Estudante.dart';

class LoginStudentResponse {
  final Estudante estudante;
  final String access;
  final String refresh;

  const LoginStudentResponse({
    required this.estudante,
    required this.access,
    required this.refresh,
  });

  factory LoginStudentResponse.fromJson(Map<String, dynamic> json) {
    final estudanteParse = Estudante.fromJson(json['aluno']);

    return LoginStudentResponse(
      estudante: estudanteParse,
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}