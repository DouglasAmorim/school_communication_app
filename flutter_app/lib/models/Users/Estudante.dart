import 'package:tcc_ifsc/Enums/typeEnum.dart';

class Estudante {
  final int id;
  final int queueId;
  final String name;
  final String username;
  final String password;
  final int turmaId;
  final typeEnum type = typeEnum.student;

  const Estudante({
    required this.id,
    required this.queueId,
    required this.name,
    required this.username,
    required this.password,
    required this.turmaId,
  });

  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
      id: json['AlunosId'],
      queueId: json['QueueId'],
      name: json['Nome'],
      username: json['Username'],
      password: json['Senha'],
      turmaId: json['TurmaId'],
    );
  }
}

class Tag {
  String name;
  int quantity;
  Tag(this.name, this.quantity);
  factory Tag.fromJson(dynamic json) {
    return Tag(json['name'] as String, json['quantity'] as int);
  }
  @override
  String toString() {
    return '{ ${this.name}, ${this.quantity} }';
  }
}