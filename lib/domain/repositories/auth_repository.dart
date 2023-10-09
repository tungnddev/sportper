import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportper/domain/entities/dummny.dart';
import 'package:sportper/domain/entities/signIn_method.dart';

abstract class AuthRepository {
  Future<User?> loginWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<User?> signInWithApple();
  Future<User?> currentUser();
  Future<void> logOut();
  Future<User?> createUserWithEmail(String email, String password);
  Future<void> resetPassword(String email);
}
