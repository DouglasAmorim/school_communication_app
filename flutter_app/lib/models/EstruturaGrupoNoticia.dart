import 'package:equatable/equatable.dart';

class EstruturaGrupoNoticia extends Equatable {
  const EstruturaGrupoNoticia({
    required this.nome,
    required this.queueId,
  });

  final String nome;
  final String queueId;

  EstruturaGrupoNoticia.fromJSON(Map<String, dynamic> map)
      : nome = map['nome'] as String,
        queueId = map['queueId'] as String;

  Map<String, dynamic> toJson() {
    return {
      'queueId': queueId,
      'nome': nome,
    };
  }

  @override
  List<Object> get props => [nome, queueId];
}
