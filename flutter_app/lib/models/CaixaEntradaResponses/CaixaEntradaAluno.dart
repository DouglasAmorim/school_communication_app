class CaixaEntradaAluno {
  final int id;
  final int schoolId;
  final int professoresId;
  final String mensagem;
  final String date;

  const CaixaEntradaAluno({
    required this.id,
    required this.schoolId,
    required this.professoresId,
    required this.mensagem,
    required this.date,
  });

  factory CaixaEntradaAluno.fromJson(Map<String, dynamic> json) {
    return CaixaEntradaAluno(
      id: json['AlunoId'],
      schoolId: json['SchoolId'],
      professoresId: json['ProfessoresId'],
      mensagem: json['Mensagem'],
      date: json['Date'],
    );
  }
}