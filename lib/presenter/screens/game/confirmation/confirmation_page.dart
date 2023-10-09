import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/home_tab_enum.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/game/confirmation/bloc/confirmation_bloc.dart';
import 'package:sportper/presenter/screens/game/confirmation/bloc/confirmation_event.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/confirmation_state.dart';

class ConfirmationPage extends StatelessWidget {
  final GameDetailVM gameVM;

  const ConfirmationPage({Key? key, required this.gameVM}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ConfirmationBloc(
                RepositoryProvider.of(context),
                RepositoryProvider.of(context),
                RepositoryProvider.of(context),
                RepositoryProvider.of(context),
                RepositoryProvider.of(context),
                RepositoryProvider.of(context)))
      ],
      child: ConfirmationWidget(
        gameVM: gameVM,
      ),
    );
  }
}

class ConfirmationWidget extends StatefulWidget {
  final GameDetailVM gameVM;

  const ConfirmationWidget({Key? key, required this.gameVM}) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: BlocListener<ConfirmationBloc, ConfirmationState>(
            listener: (context, state) {
              if (state is ConfirmationFetchFailed) {
                AppExceptionHandle.handle(context, state.error);
              } else if (state is ConfirmationShowLoading) {
                LoadingDialog.show(context);
              } else if (state is ConfirmationHideLoading) {
                Navigator.pop(context);
              } else if (state is ConfirmationJoinSuccessful) {
                RxBusService().add(
                  RxBusName.HOME_SCREEN_CHANGE_TAB,
                  value: HomeTab.myGames,
                );
                Navigator.popUntil(context, ModalRoute.withName(Routes.home));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SportperAppBar(
                  title: Strings.confirmation,
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(child: _getMainView()),
                Padding(
                  padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(10),
                      bottom: getProportionateScreenHeight(50),
                      left: 24,
                      right: 24),
                  child: SportperButton(
                    text: Strings.confirmJoining,
                    onPress: () {
                      BlocProvider.of<ConfirmationBloc>(context)
                          .add(ConfirmationJoin(widget.gameVM));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMainView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            double widthImage = constraints.maxWidth;
            double heightImage = constraints.maxWidth / 327 * 176;
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CacheImage(
                height: heightImage,
                width: widthImage,
                url: widget.gameVM.game.image,
              ),
            );
          }),
          SizedBox(
            height: getProportionateScreenHeight(50),
          ),
          Text(
            '${widget.gameVM.timeDisplay}\n${widget.gameVM.game.course.clubName}',
            style: SportperStyle.boldStyle.copyWith(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: getProportionateScreenHeight(35),
          ),
          Text(
            '${Strings.youAreJoining} "${widget.gameVM.game.title}"',
            style: SportperStyle.baseStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
