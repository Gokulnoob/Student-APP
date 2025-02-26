import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // ✅ Sign Up
  Future<String> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ✅ Sign In
  Future<String> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ✅ Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // ✅ Check Auth State
  Stream<User?> get user => _firebaseAuth.authStateChanges();
}
