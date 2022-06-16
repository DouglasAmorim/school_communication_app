import 'package:tcc_ifsc/Enums/typeEnum.dart';

class EstruturaMensagem {
  String? message;
  String? date;

  String? receiverId;
  String? receiverName;
  String? receiverType;

  String? senderId;
  String? senderName;
  String? senderType;


  EstruturaMensagem({
    this.message,
    this.date,
    this.receiverId,
    this.receiverName,
    this.receiverType,
    this.senderId,
    this.senderName,
    this.senderType
  });
}
