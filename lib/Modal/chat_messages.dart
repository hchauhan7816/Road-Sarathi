import 'package:flutter/foundation.dart';

class ModalChatMessages with ChangeNotifier {
  String message;
  String sendBy;
  bool text;
  bool isLocation;
  double latitude;
  double longitude;
  int time;

  ModalChatMessages({
    required this.message,
    required this.sendBy,
    required this.text,
    required this.time,
    required this.isLocation,
    this.latitude = 0,
    this.longitude = 0,
  });

  factory ModalChatMessages.fromJson(Map<String, dynamic> parsedJson) {
    return ModalChatMessages(
      message: parsedJson['message'] ?? '',
      sendBy: parsedJson['sendBy'] ?? '',
      text: parsedJson['text'] ?? '',
      time: parsedJson['time'] ?? '',
      isLocation: parsedJson['isLocation'] ?? '',
      latitude: parsedJson['latitude'] ?? '',
      longitude: parsedJson['longitude'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "sendBy": sendBy,
        "text": text,
        "isLocation": isLocation,
        "time": time,
        "latitude": latitude,
        "longitude": longitude,
      };
}
