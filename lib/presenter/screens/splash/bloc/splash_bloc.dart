import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/screens/shared/location_service.dart';
import 'package:sportper/presenter/screens/shared/notification_service.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  AuthRepository authRepository;
  UserRepository userRepository;

  SplashBloc(this.authRepository, this.userRepository) : super(SplashInitial());

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is SplashStartInit) {
      try {
        await Future.delayed(Duration(seconds: 1));
        await NotificationService.instance.init();
        await requestNotificationPermission();
        final result = LocationService.instance.requestPermission();
        final userFirebase = await authRepository.currentUser();
        if (userFirebase == null) {
          yield SplashOpenLogin();
          return;
        }
        // check fcm Token
        String? token = await FirebaseMessaging.instance.getToken();
        SportperUser? user = await userRepository.getUser(userFirebase.uid);
        if (token == null || user == null) {
          yield SplashOpenLogin();
          return;
        }
        if (token != user.fcmToken) {
          // login to another device
          await authRepository.logOut();
          yield SplashOpenLogin();
          return;
        }
        yield SplashOpenHome();
      } catch (err) {
        yield SplashError(err);
      }

    }
  }

  Future<void> requestNotificationPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}