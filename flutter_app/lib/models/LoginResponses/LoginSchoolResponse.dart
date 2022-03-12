import 'package:tcc_ifsc/Enums/typeEnum.dart';
import '../Users/Estudante.dart';

class LoginSchoolResponse {
  final Estudante school;
  final String access;
  final String refresh;

  const LoginSchoolResponse({
    required this.school,
    required this.access,
    required this.refresh,
  });

  factory LoginSchoolResponse.fromJson(Map<String, dynamic> json) {
    final schoolParse = Estudante.fromJson(json['escola']);

    return LoginSchoolResponse(
      school: schoolParse,
      access: json['access'],
      refresh: json['refresh'],
    );
  }
}