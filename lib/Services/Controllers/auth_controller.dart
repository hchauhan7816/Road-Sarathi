import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Modal/users.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';
import 'package:sadak/Pages/Conversation%20Rooms/conversation_rooms.dart';
import 'package:sadak/Pages/Home%20Page/home.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'dart:developer' as dev;

class FirebaseHelper extends GetxController {
  static const String _USERS = "users";
  static const String _EMAIL = "email";
  static const String _CHATROOM = "chatroom";
  static const String _CHATS = "chats";
  static const String _TIME = "time";
  static const String _CHATROOMID = "chatroomId";
  static const String _AUTHORITY = "authority";
  static const String _LOCALAUTHORITY = "localauthority";
  static const String _HIGHERAUTHORITY = "higherauthority";
  static const String _LOCALAUTHORITYMAIL = "localauthority@gmail.com";
  static const String _HIGHERAUTHORITYMAIL = "higherauthority@gmail.com";

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final Rxn<User> firebaseUser = Rxn<User>();

  String? get user => firebaseUser.value?.email;

  @override
  // ignore: must_call_super
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
  }

  void signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      User? user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user == null) {
        Get.snackbar("Error while Sign Up", "Cannot create account!",
            duration: const Duration(seconds: 5));
      } else {
        await firebaseFirestore
            .collection(_USERS)
            .doc(auth.currentUser!.uid)
            .set(ModalUser(name: name, email: email, status: 0).toJson());

        Get.snackbar("Congratulations", "Account created successfully");
        Get.offAll(() => OnBoarding());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error while Sign Up", e.message.toString(),
          duration: const Duration(seconds: 5));
    }
  }

  void signIn({required String email, required String password}) async {
    try {
      // dev.log("email :: $email   \n\n password :: $password");

      Map<String, dynamic>? x;

      await firebaseFirestore
          .collection(_USERS)
          .where(_EMAIL, isEqualTo: email)
          .get()
          .then((value) {
        value.docs.isNotEmpty ? x = value.docs[0].data() : x = null;
      });

      if (x != null && x!['status'] == 0) {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Get.offAll(() => HomePage()));

        Constants.myEmail = auth.currentUser!.email!;
      } else {
        Get.snackbar("Error while Login", "Not a user id",
            duration: const Duration(seconds: 5));
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error while Login", e.message.toString(),
          duration: const Duration(seconds: 5));
    }
  }

  void signInGovernment(
      {required String email, required String password}) async {
    try {
      // dev.log("email :: $email   \n\n password :: $password");

      // todo - Must have status 1 or 2
      Map<String, dynamic>? x;

      await firebaseFirestore
          .collection(_USERS)
          .where(_EMAIL, isEqualTo: email)
          .get()
          .then((value) {
        value.docs.isNotEmpty ? x = value.docs[0].data() : x = null;
      });

      if (x != null && x!['status'] != 0) {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Get.offAll(() => GovConversationRooms()));

        Constants.myEmail = auth.currentUser!.email!;
      } else {
        Get.snackbar("Error while Login", "Not a Government user id",
            duration: const Duration(seconds: 5));
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error while Login", e.message.toString(),
          duration: const Duration(seconds: 5));
    }
  }

  void signout() async {
    try {
      await auth.signOut().then((value) => Get.offAll(() => OnBoarding()));
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error while Sign Out", e.message.toString(),
          duration: const Duration(seconds: 5));
    }
  }

  Future<List<ModalUser>> searchUsers(String val) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection(_USERS)
        .where(_EMAIL, isGreaterThanOrEqualTo: val)
        .where(_EMAIL, isLessThanOrEqualTo: val + 'z')
        .where(_EMAIL, isNotEqualTo: Constants.myEmail)
        .get();

    var userList =
        querySnapshot.docs.map((e) => ModalUser.fromJson(e.data())).toList();

    return userList;
  }

  Future<List<ModalUser>> searchWithAlreadyConnectedUsers(
      {required String userEmail}) async {
    // Todo check only in connected Users
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection(_USERS)
        .where(_EMAIL, isGreaterThanOrEqualTo: userEmail)
        .where(_EMAIL, isLessThanOrEqualTo: userEmail + 'z')
        .where(_EMAIL, isNotEqualTo: Constants.myEmail)
        .get();

    var userList =
        querySnapshot.docs.map((e) => ModalUser.fromJson(e.data())).toList();

    return userList;

    // QuerySnapshot<Map<String, dynamic>> querySnapshot = FirebaseFirestore.instance
    //     .collection(_CHATROOMID)
    //     .where(_USERS, arrayContains: userEmail),
    //     .snapshots();

    // var userList =
    //     querySnapshot.docs.map((e) => ModalUser.fromJson(e.data())).toList();

    //     return userList;
  }

  setConversationMessages({required String chatroomId, required messageMap}) {
    FirebaseFirestore.instance
        .collection(_CHATROOM)
        .doc(chatroomId)
        .collection(_CHATS)
        .add(messageMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getConversationMessages(
      {required String chatroomId}) {
    return FirebaseFirestore.instance
        .collection(_CHATROOM)
        .doc(chatroomId)
        .collection(_CHATS)
        .orderBy(_TIME)
        .snapshots();
  }

  createChatRooms(
      {required String userEmail1,
      required String userEmail2,
      required chatroomMap,
      required String chatroomId}) {
    // dev.log("Here createChatRooms");
    FirebaseFirestore.instance
        .collection(_CHATROOM)
        .doc(chatroomId)
        .set(chatroomMap);
    // dev.log("Done Here createChatRooms");
  }

  // checkCheckroom({required String userEmail1, required String userEmail2}) async {
  //   String id = getChatroomId(userEmail1: userEmail1, userEmail2: userEmail2);

  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
  //       .collection(_CHATROOM)
  //       .where(_EMAIL, isGreaterThanOrEqualTo: userEmail)
  //       .where(_EMAIL, isLessThanOrEqualTo: userEmail + 'z')
  //       .where(_EMAIL, isNotEqualTo: Constants.myEmail)
  //       .get();

  //   var userList =
  //       querySnapshot.docs.map((e) => ModalUser.fromJson(e.data())).toList();

  //   return userList;
  // }

  getChatroomId(
      {required String userEmail1,
      required String userEmail2,
      required int val}) {
    String temp;
    // dev.log("$userEmail1 \n\n\n $userEmail2");
    temp =
        "${userEmail1.toLowerCase()}_${userEmail2.toLowerCase()}_${val.toString()}";

    // dev.log("${userEmail1.toLowerCase().codeUnitAt(0)}");
    // dev.log("${userEmail2.toLowerCase().codeUnitAt(0)}");

    return temp;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAuthorityChatRooms(
      {required String userEmail}) {
    return firebaseFirestore
        .collection(_CHATROOM)
        .where(_AUTHORITY, isEqualTo: userEmail)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomsLocalAuthority(
      {required String userEmail}) {
    return firebaseFirestore
        .collection(_CHATROOM)
        .where(_USERS, isEqualTo: userEmail)
        .where(_AUTHORITY, isEqualTo: _LOCALAUTHORITYMAIL)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomsHigherAuthority(
      {required String userEmail}) {
    return firebaseFirestore
        .collection(_CHATROOM)
        .where(_USERS, isEqualTo: userEmail)
        .where(_AUTHORITY, isEqualTo: _HIGHERAUTHORITYMAIL)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomsUsingChatroomId(
      {required String chatroomId}) {
    return firebaseFirestore
        .collection(_CHATROOM)
        .where(_CHATROOMID, isEqualTo: chatroomId)
        .snapshots();
  }
}
