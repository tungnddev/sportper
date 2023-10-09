import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportper/data/local/services/hive.dart';
import 'package:sportper/data/remote/services/auth_service.dart';
import 'package:sportper/domain/entities/signIn_method.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImp extends AuthRepository {

  AuthRepositoryImp._privateConstructor();

  static final AuthRepository instance = AuthRepositoryImp._privateConstructor();
  final HiveService hiveService = HiveService.instance;
  final AuthService authService = AuthService.instance;

  @override
  Future<User?> loginWithEmail(String email, String password) async {
      final userCre = await authService.signInWithEmail(email, password);
      return userCre.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    return authService.signInWithGoogle();
  }

  @override
  Future<User?> signInWithApple() async {
    return authService.signInWithApple();
  }


  @override
  Future<User?> currentUser() {
    return authService.currentUser();
  }

  @override
  Future<void> logOut() async {
    await authService.logOut();
  }

  @override
  Future<User?> createUserWithEmail(String email, String password) {
    return authService.createUserWithEmail(email, password);
  }

  @override
  Future<void> resetPassword(String email) {
    return authService.resetPassword(email);
  }

}
