import 'package:flutter/foundation.dart';

class ModalChatMessages with ChangeNotifier {
  String message;
  String sendby;
  bool text;
  int time;

  // Default Values
  ModalChatMessages({
    this.message = '',
    this.sendby = '',
    this.text = false,
    this.time = 0,
  });

  factory ModalChatMessages.fromJson(Map<String, dynamic> parsedJson) {
    return ModalChatMessages(
      message: parsedJson['message'] ?? '',
      sendby: parsedJson['sendby'] ?? '',
      text: parsedJson['text'] ?? '',
      time: parsedJson['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "sendBy": sendby,
        "text": text,
        "time": time,
      };
}
