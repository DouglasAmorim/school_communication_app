class CaixaEntradaPais {
  final int id;
  final int professoresId;
  final int schoolId;
  final int alunosId;
  final String mensagem;
  final String date;

  const CaixaEntradaPais({
    required this.id,
    required this.professoresId,
    required this.schoolId,
    required this.alunosId,
    required this.mensagem,
    required this.date,
  });

  factory CaixaEntradaPais.fromJson(Map<String, dynamic> json) {
    return CaixaEntradaPais(
      id: json['PaisId'],
      professoresId: json['ProfessoresId'],
      schoolId: json['SchoolId'],
      alunosId: json['AlunoId'],
      mensagem: json['Mensagem'],
      date: json['Date'],
    );
  }
}