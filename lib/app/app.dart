import 'package:firebase_core/firebase_core.dart';
import 'package:sportper/data/local/services/hive.dart';
import 'package:sportper/data/repositories/auth_repository.dart';
import 'package:sportper/data/repositories/chat_repository_imp.dart';
import 'package:sportper/data/repositories/course_repository_imp.dart';
import 'package:sportper/data/repositories/friend_repository_imp.dart';
import 'package:sportper/data/repositories/game_invitation_repository_imp.dart';
import 'package:sportper/data/repositories/game_repository_imp.dart';
import 'package:sportper/data/repositories/notification_repository_imp.dart';
import 'package:sportper/data/repositories/post_repository_imp.dart';
import 'package:sportper/data/repositories/storage_repository_imp.dart';
import 'package:sportper/data/repositories/user_repository_imp.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/chat_repository.dart';
import 'package:sportper/domain/repositories/course_repository.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/game_invitation_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/post_repository.dart';
import 'package:sportper/domain/repositories/storate_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/env/environment.dart';
import 'package:sportper/generated/l10n.dart';
import 'package:sportper/presenter/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:hive/hive.dart';

void mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService.instance.initialize();
  runApp(SportperApp());
}

class SportperApp extends StatelessWidget {
  const SportperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepositoryImp.instance, lazy: true,),
        RepositoryProvider<UserRepository>(create: (context) => UserRepositoryImp.instance, lazy: true,),
        RepositoryProvider<GameRepository>(create: (context) => GameRepositoryImp.instance, lazy: true,),
        RepositoryProvider<CourseRepository>(create: (context) => CourseRepositoryImp.instance, lazy: true,),
        RepositoryProvider<StorageRepository>(create: (context) => StorageRepositoryImp.instance, lazy: true,),
        RepositoryProvider<FriendRepository>(create: (context) => FriendRepositoryImp.instance, lazy: true,),
        RepositoryProvider<NotificationRepository>(create: (context) => NotificationRepositoryImp.instance, lazy: true,),
        RepositoryProvider<ChatRepository>(create: (context) => ChatRepositoryImp.instance, lazy: true,),
        RepositoryProvider<GameInvitationRepository>(create: (context) => GameInvitationRepositoryImp.instance, lazy: true,),
        RepositoryProvider<PostRepository>(create: (context) => PostRepositoryImp.instance, lazy: true,),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        onGenerateRoute: RouteGenerator.generateRoute,
        locale: Locale("en"),
        theme: ThemeData(
          primaryColor: ColorUtils.colorTheme,
          fontFamily: 'Avenir'
        ),
        builder: (BuildContext context, Widget? widget) {
          if (!Environment.isDebugMode()) {
            setErrorBuilder();
          }
          return widget ?? Container();
        },
      ),
    );
  }

  void setErrorBuilder() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return Container();
    };
  }
}