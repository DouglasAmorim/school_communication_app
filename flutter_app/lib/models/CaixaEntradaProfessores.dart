class CaixaEntradaProfessores {
  final int id;
  final int schoolId;
  final int paisId;
  final int alunosId;
  final String mensagem;
  final String date;

  const CaixaEntradaProfessores({
    required this.id,
    required this.schoolId,
    required this.paisId,
    required this.alunosId,
    required this.mensagem,
    required this.date,
  });

  factory CaixaEntradaProfessores.fromJson(Map<String, dynamic> json) {
    return CaixaEntradaProfessores(
      id: json['ProfessoresId'],
      schoolId: json['SchoolId'],
      paisId: json['PaisId'],
      alunosId: json['AlunoId'],
      mensagem: json['Mensagem'],
      date: json['Date'],
    );
  }
}