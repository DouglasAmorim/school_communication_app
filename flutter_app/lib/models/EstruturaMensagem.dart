import 'package:equatable/equatable.dart';

class EstruturaMensagem extends Equatable {
  const EstruturaMensagem({
    required this.message,
    required this.date,
    required this.receiverId,
    required this.receiverName,
    required this.receiverType,
    required this.senderId,
    required this.senderName,
    required this.senderType,
  });

  final String message;
  final String date;

  final String receiverId;
  final String receiverName;
  final String receiverType;

  final String senderId;
  final String senderName;
  final String senderType;

  EstruturaMensagem.fromJSON(Map<String, dynamic> map)
      : message = map['message'] as String,
        date = map['date'] as String,
        receiverId = map['receiverId'] as String,
        receiverName = map['receiverName'] as String,
        receiverType = map['receiverType'] as String,
        senderId = map['senderId'] as String,
        senderName = map['senderName'] as String,
        senderType = map['senderType'] as String;

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'date': date,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverType': receiverType,
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
    };
  }

  @override
  List<Object> get props => [message, date, receiverId, receiverName, receiverType, senderId, senderName, senderType];
}
