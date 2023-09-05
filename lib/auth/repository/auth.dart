import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> createUserWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> isUserSignedIn() async {
    await Future.delayed(const Duration(seconds: 1));

    var prefs = await SharedPreferences.getInstance();
    bool? isSignedIn = prefs.getBool('isSignedIn');

    return isSignedIn ?? false;
  }
}
