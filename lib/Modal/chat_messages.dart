import 'package:flutter/foundation.dart';

class ModalChatMessages with ChangeNotifier {
  String message;
  String sendBy;
  bool text;
  int time;

  // Default Values
  ModalChatMessages({
    required this.message,
    required this.sendBy,
    required this.text,
    required this.time,
  });

  factory ModalChatMessages.fromJson(Map<String, dynamic> parsedJson) {
    return ModalChatMessages(
      message: parsedJson['message'] ?? '',
      sendBy: parsedJson['sendBy'] ?? '',
      text: parsedJson['text'] ?? '',
      time: parsedJson['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "sendBy": sendBy,
        "text": text,
        "time": time,
      };
}
