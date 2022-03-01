import 'package:tcc_ifsc/Enums/typeEnum.dart';

class EstruturaMensagem {
  String? mensagem;
  String? date;
  bool? isReceived;
  int? contactId;
  typeEnum? contactType;

  EstruturaMensagem({this.mensagem, this.date, this.isReceived, this.contactId, this.contactType});
}
