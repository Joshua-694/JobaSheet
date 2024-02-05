import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  //instance of firebase
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Sing up method
  Future<User?> singUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return credential.user;
    } catch (e) {
      print('Some error occured');
    }
    return null;
  }

  //Sing in method

  Future<User?> singInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential.user;
    } catch (e) {
      print('Some error occured');
    }
    return null;
  }

  static signInWithCredential(AuthCredential credential) {}
}
