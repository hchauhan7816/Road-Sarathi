import 'package:flutter/foundation.dart';

class ModalUser with ChangeNotifier {
  String email;
  String name;
  int status;

  ModalUser({
    this.email = '',
    this.name = '',
    this.status = 0,
  });

  factory ModalUser.fromJson(Map<String, dynamic> parsedJson) {
    return ModalUser(
      email: parsedJson['email'] ?? '',
      name: parsedJson['name'] ?? '',
      status: parsedJson['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "status": status,
      };
}
