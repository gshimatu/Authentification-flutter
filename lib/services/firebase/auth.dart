import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Login avec email et mot de passe
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Créer un utilisateur avec email et mot de passe
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login avec Google
  Future<dynamic> signInWithGoogle() async {
    try {
      final gsi = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: '258582651622-lf7dvapvv32q5re1llpubuq4fin30e5l.apps.googleusercontent.com',
        // 258582651622-lf7dvapvv32q5re1llpubuq4fin30e5l.apps.googleusercontent.com
        );
      final GoogleSignInAccount? googleUser = await gsi.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on Exception catch (e) {
      print('exceprion-> $e');
      return null;
    }
  }
}
