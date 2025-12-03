import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

  // Login avec Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // 1. Déclencher la connexion via le SDK Facebook
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      // 2. Vérifier si l'utilisateur a validé la connexion
      if (result.status == LoginStatus.success) {
        // 3. Récupérer le token d'accès
        final AccessToken accessToken = result.accessToken!;

        // 4. Créer les identifiants pour Firebase
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // 5. Connecter à Firebase
        return await _firebaseAuth.signInWithCredential(credential);
      } else {
        // L'utilisateur a annulé ou erreur SDK Facebook
        print('Facebook login status: ${result.status}');
        print('Message: ${result.message}');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      // Erreurs liées à Firebase (ex: compte existe déjà avec un autre provider)
      print('FirebaseAuthException: ${e.message}');
      rethrow; 
    } catch (e) {
      // Erreurs générales
      print('Exception during Facebook Login: $e');
      return null;
    }
  }
}
