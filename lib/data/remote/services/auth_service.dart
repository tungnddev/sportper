import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();

  Future<UserCredential> signInWithEmail(String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // user cancel or and other error
    if (googleAuth == null) return null;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final firebaseUser = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    if (firebaseUser == null) return null;
    firebaseUser.updateDisplayName(googleUser?.displayName);
    firebaseUser.updatePhotoURL(googleUser?.photoUrl);
    return firebaseUser;
  }

  Future<User?> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final firebaseUser = (await FirebaseAuth.instance.signInWithCredential(oauthCredential)).user;
    if (firebaseUser == null) return null;
    firebaseUser.updateDisplayName(appleCredential.givenName);
    return firebaseUser;
  }

  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> currentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> logOut() async {
    bool isSingInGoogle = await GoogleSignIn().isSignedIn();
    if (isSingInGoogle) {
      await GoogleSignIn().signOut();
    }
    await FirebaseAuth.instance.signOut();
  }

  Future<User?> createUserWithEmail(String email, String password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) => value.user);
  }

  Future<void> resetPassword(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
