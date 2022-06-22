import 'package:equatable/equatable.dart';

class EstruturaNoticia extends Equatable {
  const EstruturaNoticia({
    required this.titulo,
    required this.message,
    required this.date,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
  });

  final String titulo;
  final String message;
  final String date;

  final String receiverId;

  final String senderId;
  final String senderName;
  final String senderType;

  EstruturaNoticia.fromJSON(Map<String, dynamic> map)
      : titulo = map['title'] as String,
        message = map['message'] as String,
        date = map['date'] as String,
        receiverId = map['receiverId'] as String,
        senderId = map['senderId'] as String,
        senderName = map['senderName'] as String,
        senderType = map['senderType'] as String;

  Map<String, dynamic> toJson() {
    return {
      'title': titulo,
      'message': message,
      'date': date,
      'receiverId': receiverId,
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
    };
  }

  @override
  List<Object> get props => [titulo, message, date, receiverId, senderId, senderName, senderType];
}
