import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/presenter/models/filter_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/presenter/screens/auth/forgot_password/forgot_password_page.dart';
import 'package:sportper/presenter/screens/auth/login/login_page.dart';
import 'package:sportper/presenter/screens/auth/register/register_page.dart';
import 'package:sportper/presenter/screens/auth/start/start_page.dart';
import 'package:sportper/presenter/screens/game/confirmation/confirmation_page.dart';
import 'package:sportper/presenter/screens/game/detail/game_detail_page.dart';
import 'package:sportper/presenter/screens/game/detail/invite/game_invitation_page.dart';
import 'package:sportper/presenter/screens/game/filter/filter_game_page.dart';
import 'package:sportper/presenter/screens/game/newgame/new_game_page.dart';
import 'package:sportper/presenter/screens/home/home_page.dart';
import 'package:sportper/presenter/screens/post/create_post/create_post_page.dart';
import 'package:sportper/presenter/screens/post/post_detail/post_detail_page.dart';
import 'package:sportper/presenter/screens/shared/photo_view_page.dart';
import 'package:sportper/presenter/screens/splash/splash_page.dart';
import 'package:sportper/presenter/screens/user/editprofile/edit_profile_page.dart';
import 'package:sportper/presenter/screens/user/profile/profile_page.dart';


import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute<dynamic>(builder: (_) => SplashPage(), settings: settings);
      case Routes.loginWithEmail:
        return MaterialPageRoute<dynamic>(builder: (_) => LoginPage(), settings: settings);
      case Routes.start:
        return MaterialPageRoute<dynamic>(builder: (_) => StartPage(), settings: settings);
      case Routes.home:
        return MaterialPageRoute<dynamic>(builder: (_) => HomePage(), settings: settings);
      case Routes.register:
        return MaterialPageRoute<dynamic>(builder: (_) => RegisterPage(), settings: settings);
      case Routes.forgotPassword:
        return MaterialPageRoute<dynamic>(builder: (_) => ForgotPasswordPage(), settings: settings);
      case Routes.gameDetail:
        return MaterialPageRoute<dynamic>(
            builder: (_) {
              if (args is Map) {
                return GameDetailPage(gameId: args['gameId'], notification: args['notification'],);
              }
              return GameDetailPage(gameId: args as String);
            },
            settings: settings);
      case Routes.gameConfirmation:
        return MaterialPageRoute<dynamic>(builder: (_) => ConfirmationPage(gameVM: args as GameDetailVM), settings: settings);
      case Routes.profile:
        return MaterialPageRoute<dynamic>(builder: (_) => ProfilePage(userId: args as String?), settings: settings);
      case Routes.editProfile:
        return MaterialPageRoute<dynamic>(builder: (_) => EditProfilePage(vm: args as SportperUserVM), settings: settings);
      case Routes.filterGame:
        return MaterialPageRoute<dynamic>(builder: (_) => FilterGamePage(currentFilter: args as FilterGameVM), settings: settings);
      case Routes.invitationGame:
        return MaterialPageRoute<dynamic>(builder: (_) => GameInvitationPage(game: args as Game), settings: settings);
      case Routes.addPost:
        return MaterialPageRoute<dynamic>(builder: (_) => CreatePostPage(postType: args as PostType,), settings: settings);
      case Routes.postDetail:
        return MaterialPageRoute<dynamic>(builder: (_) => PostDetailPage(postId: args as String), settings: settings);
      case Routes.photoView:
        return MaterialPageRoute<dynamic>(builder: (_) => PhotoViewPage(url: args as String), settings: settings);
      case Routes.newGame:
        return MaterialPageRoute<dynamic>(builder: (_) => NewGamePage(), settings: settings);
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
