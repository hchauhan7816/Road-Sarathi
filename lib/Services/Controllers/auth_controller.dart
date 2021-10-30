import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sadak/Pages/Home%20Page/home.dart';
import 'package:sadak/Pages/Login%20Signup%20Page/navigate_login_signup.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Rxn<User> firebaseUser = Rxn<User>();

  String? get user => firebaseUser.value?.email;

  @override
  // ignore: must_call_super
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
  }

  void signUp({required String email, required String password}) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => Get.offAllNamed("/navigator"));
      Get.snackbar("Congratulations", "Account created successfully");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error while Sign Up", e.message.toString(),
          duration: const Duration(seconds: 5));
    }
  }

  void signIn({required String email, required String password}) async {
    try {
      // todo Temp. /chat
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Get.offAllNamed("/chat"));
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error while Login", e.message.toString(),
          duration: const Duration(seconds: 5));
    }
  }

  void signout() async {
    try {
      await auth.signOut().then((value) => Get.offAllNamed("/navigator"));
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error while Sign Out", e.message.toString(),
          duration: const Duration(seconds: 5));
    }
  }
}
