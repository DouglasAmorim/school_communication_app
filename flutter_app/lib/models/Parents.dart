class Parents {
  final int id;
  final int queueId;
  final String name;
  final String username;
  final String password;
  final String telefone;
  final String email;

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
    print("JSON ${json}");
    print(json['PaisId']);
    print(json['QueueId']);
    print(json['Nome']);
    print(json['Username']);
    print(json['Telefone']);
    print(json['Email']);

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