import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/game_player.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/home_tab_enum.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/game/detail/detailoverview/bloc/state.dart';
import 'package:sportper/presenter/screens/game/join/widgets/avatar_list_widget.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/show_alert.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sportper/domain/entities/notification.dart' as N;

import 'bloc/bloc.dart';
import 'bloc/event.dart';

class GameDetailOverviewPage extends StatelessWidget {
  final String gameID;
  final N.Notification? notification;

  const GameDetailOverviewPage(
      {Key? key, required this.gameID, this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => GameDetailOverviewBloc(
              RepositoryProvider.of(context),
              gameID,
              RepositoryProvider.of(context),
              RepositoryProvider.of(context),
              notification,
              RepositoryProvider.of(context),
              RepositoryProvider.of(context)))
    ], child: GameDetailOverviewWidget());
  }
}

class GameDetailOverviewWidget extends StatefulWidget {
  const GameDetailOverviewWidget({Key? key}) : super(key: key);

  @override
  _GameDetailOverviewWidgetState createState() =>
      _GameDetailOverviewWidgetState();
}

class _GameDetailOverviewWidgetState extends State<GameDetailOverviewWidget> {
  late GameDetailOverviewBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(GameDetailOverviewFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameDetailOverviewBloc, GameDetailOverviewState>(
        bloc: bloc,
        listener: (BuildContext context, state) {
          if (state is GameDetailOverviewFetchFailed) {
            AppExceptionHandle.handle(context, state.error);
          } else if (state is GameDetailShowLoading) {
            LoadingDialog.show(context);
          } else if (state is GameDetailHideLoading) {
            Navigator.pop(context);
          } else if (state is GameDetailJoinSuccessful) {
            RxBusService().add(
              RxBusName.HOME_SCREEN_CHANGE_TAB,
              value: HomeTab.myGames,
            );
            Navigator.pop(context);
          } else if (state is GameDetailAcceptSuccessful) {
            Navigator.pushReplacementNamed(context, Routes.gameConfirmation,
                arguments: state.lastGameVM);
          } else if (state is GameDetailDeclineSuccessful) {
            Navigator.pop(context);
          }
        },
        buildWhen: (pre, next) =>
            next is GameDetailOverviewLoading ||
            next is GameDetailOverviewFetchSuccessful,
        builder: (context, state) {
          if (state is GameDetailOverviewLoading) {
            return LoadingView();
          }
          if (state is GameDetailOverviewFetchSuccessful) {
            GameDetailVM vm = state.gameVM;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LayoutBuilder(builder: (context, constraints) {
                            double widthImage = constraints.maxWidth;
                            double heightImage =
                                constraints.maxWidth / 327 * 160;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CacheImage(
                                height: heightImage,
                                width: widthImage,
                                url: vm.game.image,
                              ),
                            );
                          }),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      vm.game.title.toUpperCase(),
                                      style: SportperStyle.boldStyle
                                          .copyWith(fontSize: 18),
                                    ),
                                    Text(
                                      vm.game.subTitle,
                                      style: SportperStyle.baseStyle,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  bloc.add(GameDetailOverviewChangeFavourite(
                                      vm.game.id));
                                },
                                child: Image.asset(
                                  vm.isFavourite
                                      ? ImagePaths.icFavouriteFill
                                      : ImagePaths.icFavouriteEmpty,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              ...vm.canInvite
                                  ? [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              Routes.invitationGame,
                                              arguments: vm.game);
                                        },
                                        child: Image.asset(
                                          ImagePaths.icShare,
                                          width: 24,
                                          height: 24,
                                        ),
                                      )
                                    ]
                                  : []
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          _buildItemLineTick(
                              ImagePaths.icCalendar, vm.timeDisplay),
                          GestureDetector(
                            onTap: () async {
                              MapsLauncher.launchQuery(vm.game.course.address);
                            },
                            child: _buildItemLineTick(
                                ImagePaths.icLocation, vm.game.course.address),
                          ),
                          if (vm.game.isBooked)
                            _buildItemLineTick(
                                ImagePaths.icTick, Strings.booked),
                          if (vm.game.isTournament)
                            _buildItemLineTick(
                                ImagePaths.icTick, Strings.tournament),
                          if (vm.game.drink)
                            _buildItemLineTick(
                                ImagePaths.icTick, Strings.drink),
                          if (vm.game.smoke)
                            _buildItemLineTick(
                                ImagePaths.icTick, Strings.smoke),
                          if (vm.game.gamble)
                            _buildItemLineTick(
                                ImagePaths.icTick, Strings.gamble),
                          _buildItemLineTick(ImagePaths.icPhone, vm.phoneText),
                          _buildItemLineTick(ImagePaths.icType, vm.typeDisplay),
                          _buildHostBy(vm),
                          Row(
                            children: [
                              _buildItemJoined(Strings.joined,
                                  '${vm.game.usersJoined.length}'),
                              // _buildItemJoined(
                              //     Strings.guests, '${vm.game.numGuests}'),
                              _buildItemJoined(Strings.slotRemaining,
                                  '${vm.remainingPlayer}')
                            ],
                          ),
                          _buildPlayerWidget(vm.playerVMs)
                        ],
                      ),
                    ),
                  ),
                  ...vm.canJoin
                      ? [
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          SportperButton(
                            text: Strings.joinThisGame,
                            onPress: () {
                              Navigator.pushNamed(
                                  context, Routes.gameConfirmation,
                                  arguments: vm);
                              // bloc.add(GameDetailJoin());
                            },
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(50),
                          )
                        ]
                      : [],
                  ...vm.showActions
                      ? [
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SportperButton(
                                text: Strings.acceptThisGame,
                                onPress: () {
                                  bloc.add(GameDetailOverviewAccept());
                                },
                              )),
                              SizedBox(width: 15),
                              Expanded(
                                child: SportperButton(
                                  text: Strings.declineThisGame,
                                  colorButton: ColorUtils.red,
                                  onPress: () {
                                    bloc.add(GameDetailOverviewDecline());
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(50),
                          )
                        ]
                      : []
                ],
              ),
            );
          }
          return Container();
        });
  }

  _buildItemLineTick(String image, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            width: 20,
            height: 20,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              style: SportperStyle.baseStyle.copyWith(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  _buildHostBy(GameDetailVM vm) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: Row(
        children: [
          AvatarCircle(size: 40, url: vm.game.host.avatar),
          // Image.asset(
          //   ImagePaths.logo,
          //   width: 40,
          //   height: 40,
          // ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: Strings.hostedBy,
                style: SportperStyle.baseStyle.copyWith(fontSize: 13),
                children: [
                  TextSpan(
                      text: vm.game.host.fullName,
                      style: SportperStyle.boldStyle.copyWith(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildItemJoined(String title, String content) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: SportperStyle.baseStyle.copyWith(fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            content,
            style: SportperStyle.boldStyle.copyWith(fontSize: 13),
          )
        ],
      ),
    ));
  }

  _buildPlayerWidget(List<PlayerVM> players) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Strings.players,
            style: SportperStyle.baseStyle.copyWith(fontSize: 13),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Row(
            children: players.map((e) => _buildJoinedAvatar(e)).toList(),
          )
          // AvatarListWidget(avatarList: players.map((e) => e.avatar).toList())
        ],
      ),
    );
  }

  Widget _buildJoinedAvatar(PlayerVM player) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: EdgeInsets.all(0),
            child: AvatarCircle(
              size: 60,
              url: player.entity.avatar,
            ),
          ),
          if (player.canDelete)
            GestureDetector(
              onTap: () {
                showConfirmDialog(context, Strings.areYouSureWantToRemove,
                    onConfirm: () {
                  bloc.add(GameDetailOverviewDeletePlayer(player.entity.id));
                });
              },
              child: Image.asset(
                ImagePaths.icDeleteImage,
                width: 20,
                height: 20,
              ),
            )
        ],
      ),
    );
  }
}
