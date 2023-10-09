import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => SplashBloc(
              RepositoryProvider.of(context),
              RepositoryProvider.of(context)))
    ], child: SplashWidget());
  }
}

class SplashWidget extends StatefulWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  late SplashBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SplashBloc>(context)..add(SplashStartInit());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashOpenLogin) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.start, (route) => false);
          }
          else if (state is SplashOpenHome) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.home, (route) => false);
          }
          else if (state is SplashError) {
            AppExceptionHandle.handle(context, state.error);
          }
        },
        bloc: bloc,
        builder: (context, state) => Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.bg), fit: BoxFit.fill)),
          child: Image.asset(
            ImagePaths.logo,
            width: 140,
            height: 140,
          ),
        ),
      ),
    );
  }
}
