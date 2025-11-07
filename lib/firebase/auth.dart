import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) 
  async {
    //validation
    if (email.isEmpty || password.isEmpty) {
      return 'Email and password cannot be empty.';
    }
    if (!RegExp(r'^.+@.+$').hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    //validation
    if (email.isEmpty || password.isEmpty) {
      return 'Email and password cannot be empty.';
    }
    if (!RegExp(r'^.+@.+$').hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}