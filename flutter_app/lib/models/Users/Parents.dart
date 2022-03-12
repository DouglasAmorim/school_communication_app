import 'package:tcc_ifsc/Enums/typeEnum.dart';

class Parents {
  final int id;
  final int queueId;
  final String name;
  final String username;
  final String password;
  final String telefone;
  final String email;
  final typeEnum type = typeEnum.parents;

  const Parents({
    required this.id,
    required this.queueId,
    required this.name,
    required this.username,
    required this.password,
    required this.email,
    required this.telefone,
  });

  factory Parents.fromJson(Map<String, dynamic> json) {
    return Parents(
      id: json['PaisId'],
      queueId: json['QueueId'],
      name: json['Nome'],
      username: json['Username'],
      password: json['Senha'],
      telefone: json['Telefone'],
      email: json['Email'],
    );
  }
}