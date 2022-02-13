class Parents {
  final int id;
  final int queueId;
  final String name;
  final String password;
  final String telefone;
  final String email;

  const Parents({
    required this.id,
    required this.queueId,
    required this.name,
    required this.password,
    required this.email,
    required this.telefone,
  });

  factory Parents.fromJson(Map<String, dynamic> json) {
    return Parents(
      id: json['PaisId'],
      queueId: json['QueueId'],
      name: json['Nome'],
      password: json['Senha'],
      telefone: json['Telefone'],
      email: json['Email'],
    );
  }
}