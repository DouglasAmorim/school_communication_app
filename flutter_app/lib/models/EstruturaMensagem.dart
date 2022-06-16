import 'package:tcc_ifsc/Enums/typeEnum.dart';

class EstruturaMensagem {
  String? message;
  String? date;
  String? receiverId;
  String? senderId;
  typeEnum? contactType;

  EstruturaMensagem({this.message, this.date, this.receiverId, this.senderId, this.contactType});
}
