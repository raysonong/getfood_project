import 'package:firebase_auth/firebase_auth.dart';
//import 'package:smartliving_project/database.dart';

class AuthenicationService {
  final FirebaseAuth _firebaseAuth;

  AuthenicationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  // Logout Function
  Future<void> logOut() async {
    // Logout the user
    await _firebaseAuth.signOut();
  }

  // Validate Password Function
  Future<bool> validatePassword(
      {User firebaseUser, String currentPassword}) async {
    // Get the data of the authenication
    AuthCredential authCredentials = EmailAuthProvider.credential(
        email: firebaseUser.email, password: currentPassword);
    try {
      // Attempt to authenicate and test if password is correct
      UserCredential authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // Update Password Function
  Future<void> updatePassword({User firebaseUser, String newPassword}) async {
    // Update new password
    firebaseUser.updatePassword(newPassword);
  }

  // Login Account Function
  Future<String> loginAccount({String email, String password}) async {
    try {
      // Attempt to sign in if password is correct
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      // Return error message
      return e.message;
    }
  }

  // Register Account Function
  Future<String> registerAccount(
      {String email, String username, int phoneNumber, String password}) async {
    try {
      // Create Account with email and password
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      // Return error message
      return e.message;
    }
  }

  // Login Anonymously
  Future<String> loginAnonymously() async {
    try {
      // Login the user anonymously
      await _firebaseAuth.signInAnonymously();
      return null;
    } on FirebaseAuthException catch (e) {
      // Return error message
      return e.message;
    }
  }
}
