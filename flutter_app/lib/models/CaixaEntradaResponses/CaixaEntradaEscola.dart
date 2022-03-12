class CaixaEntradaEscola {
  final int id;
  final int paisId;
  final int professoresId;
  final int alunosId;
  final String mensagem;
  final String date;

  const CaixaEntradaEscola({
    required this.id,
    required this.paisId,
    required this.professoresId,
    required this.alunosId,
    required this.mensagem,
    required this.date,
  });

  factory CaixaEntradaEscola.fromJson(Map<String, dynamic> json) {
    return CaixaEntradaEscola(
      id: json['SchoolId'],
      paisId: json['PaisId'],
      professoresId: json['ProfessoresId'],
      alunosId: json['AlunoId'],
      mensagem: json['Mensagem'],
      date: json['Date'],
    );
  }
}