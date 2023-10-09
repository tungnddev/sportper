import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/signIn_method.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/utils/definded/avatars.dart';
import 'package:uuid/uuid.dart';

import 'start_event.dart';
import 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  AuthRepository authRepository;
  UserRepository userRepository;

  StartBloc(this.authRepository, this.userRepository) : super(StartInitial());

  @override
  Stream<StartState> mapEventToState(StartEvent event) async* {
    if (event is StartLoginGoogle) {
      try {
        yield StartLoading();
        final firebaseUser = await authRepository.signInWithGoogle();

        if (firebaseUser == null) {
          yield StartHideLoading();
          return;
        }

        final sportperUser = await userRepository.getUser(firebaseUser.uid);
        if (sportperUser == null) {
          // create new user
          final newSportperUser =
              await getUserByFirebase(firebaseUser, SignInMethod.google);
          await userRepository.addUser(firebaseUser.uid, newSportperUser);
        } else {
          // already
          // add new fcm token
          await updateNewConfig(firebaseUser.uid);
        }
        yield StartHideLoading();
        yield StartOpenHome();
      } catch (e) {
        yield StartHideLoading();
        yield StartLoginFail(e);
      }
    } else if (event is StartLoginApple) {
      try {
        yield StartLoading();
        final firebaseUser = await authRepository.signInWithApple();

        if (firebaseUser == null) {
          yield StartHideLoading();
          return;
        }

        final sportperUser = await userRepository.getUser(firebaseUser.uid);
        if (sportperUser == null) {
          // create new user
          final newSportperUser =
              await getUserByFirebase(firebaseUser, SignInMethod.apple);
          await userRepository.addUser(firebaseUser.uid, newSportperUser);
        } else {
          // already
          // add new fcm token
          await updateNewConfig(firebaseUser.uid);
        }
        yield StartHideLoading();
        yield StartOpenHome();
      } catch (e) {
        yield StartHideLoading();
        yield StartLoginFail(e);
      }
    }
  }

  Future<void> updateNewConfig(String id) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    await userRepository.updateFcmToken(id, token);
  }

  Future<SportperUser> getUserByFirebase(User user, SignInMethod method) async {
    String? token = await FirebaseMessaging.instance.getToken();
    String id = Uuid().v4();
    return SportperUser(
        '',
        id,
        user.displayName ?? 'User${id.substring(0, 6)}',
        '',
        '',
        '',
        token ?? '',
        false,
        false,
        false,
        false,
        [],
        method,
        DateTime.now().toUtc().toIso8601String(),
        user.photoURL ?? AvatarGenerate.get(),
        [],
        null,
        0,
        null,
        SportperUserRole.user);
  }
}
