class Professor {
  final int id;
  final int queueId;
  final String name;
  final String password;

  const Professor({
    required this.id,
    required this.queueId,
    required this.name,
    required this.password,
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: json['ProfessoresId'],
      queueId: json['QueueId'],
      name: json['Nome'],
      password: json['Senha'],
    );
  }
}