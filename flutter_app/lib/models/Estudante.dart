class Estudante {
  final int id;
  final int queueId;
  final String name;
  final String username;
  final String password;
  final int turmaId;

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