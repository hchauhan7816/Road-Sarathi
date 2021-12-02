import 'package:flutter/foundation.dart';

class ChatroomModal with ChangeNotifier {
  String users;
  String authority;
  String chatroomId;
  String title;
  bool completed;
  bool isWithHigher;
  DateTime dueDate;

  // Default Values
  ChatroomModal({
    required this.users,
    required this.authority,
    required this.chatroomId,
    required this.title,
    required this.isWithHigher,
    required this.completed,
    required this.dueDate,
  });

  factory ChatroomModal.fromJson(Map<String, dynamic> parsedJson) {
    return ChatroomModal(
      users: parsedJson['users'] ?? '',
      authority: parsedJson['authority'] ?? '',
      chatroomId: parsedJson['chatroomId'] ?? '',
      title: parsedJson['title'] ?? '',
      isWithHigher: parsedJson['isWithHigher'] ?? '',
      completed: parsedJson['completed'] ?? '',
      dueDate: parsedJson['dueDate'].toDate() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "users": users,
        "authority": authority,
        "chatroomId": chatroomId,
        "title": title,
        "isWithHigher": isWithHigher,
        "completed": completed,
        "dueDate": dueDate,
      };
}
