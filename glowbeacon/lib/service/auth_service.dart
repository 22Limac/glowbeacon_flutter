import 'package:firebase_auth/firebase_auth.dart';
import 'package:glowbeacon/helper/helper_function.dart';
import 'package:glowbeacon/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// login

  Future loginWithUserNameAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user date.
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// register

  Future registerUserWithEmailAndPassword(
      String username, String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user date.
        await DatabaseService(uid: user.uid)
            .savingUserData(username, fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// signout

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveFullNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
