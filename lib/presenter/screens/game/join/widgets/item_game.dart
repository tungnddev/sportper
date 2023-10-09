import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:intl/intl.dart';
import 'package:sportper/utils/extensions/date.dart';

import 'avatar_list_widget.dart';

class GameItemWidget extends StatelessWidget {
  final GameVM vm;
  final Function()? onTap;
  final Function()? onTapFavourite;
  final Function()? onTapShare;

  const GameItemWidget(
      {Key? key,
      required this.vm,
      this.onTap,
      this.onTapFavourite,
      this.onTapShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double widthImage = constraints.maxWidth;
      double heightImage = constraints.maxWidth / 327 * 185;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                Stack(
                  children: [
                    CacheImage(
                        url: vm.game.image,
                        height: heightImage,
                        width: widthImage),
                    Positioned.fill(
                        child: Container(
                      color: Color(0xFF000000).withAlpha(100),
                    )),
                    Positioned.fill(
                        child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      vm.game.title,
                                      style: SportperStyle.boldStyle.copyWith(
                                          color: Colors.white, fontSize: 17),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: Strings.hostedBy,
                                        style: SportperStyle.baseStyle.copyWith(
                                            fontSize: 12, color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text: vm.game.host.fullName,
                                              style: SportperStyle.boldStyle
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white)),
                                          TextSpan(
                                              text: ' ${vm.hostText}',
                                              style: SportperStyle.baseStyle
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      vm.game.subTitle,
                                      style: SportperStyle.baseStyle.copyWith(
                                          color: Colors.white, fontSize: 15),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: onTapFavourite,
                                child: Image.asset(
                                  vm.isFavourite
                                      ? ImagePaths.icFavouriteFill
                                      : ImagePaths.icFavouriteEmpty,
                                  color: Colors.white,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              // GestureDetector(
                              //   onTap: onTapShare,
                              //   child: Image.asset(
                              //     ImagePaths.icShare,
                              //     color: Colors.white,
                              //     width: 24,
                              //     height: 24,
                              //   ),
                              // )
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          // Row(
                          //   children: [
                          //     Image.asset(
                          //       ImagePaths.icCalendar,
                          //       width: 20,
                          //       height: 20,
                          //       color: Colors.white,
                          //     ),
                          //     SizedBox(
                          //       width: 8,
                          //     ),
                          //     Expanded(
                          //       child: Text(
                          //         vm.timeDisplay,
                          //         style: SportperStyle.baseStyle
                          //             .copyWith(color: Colors.white, fontSize: 13),
                          //         maxLines: 1,
                          //         overflow: TextOverflow.ellipsis,
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                ImagePaths.icCalendar,
                                width: 20,
                                height: 20,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  vm.game.time.timeAwayFromNow,
                                  style: SportperStyle.baseStyle.copyWith(
                                      color: Colors.white, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImagePaths.distance,
                                width: 20,
                                height: 20,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  vm.distance == null
                                      ? '${Strings.notSet}'
                                      : '${vm.distance!.toStringAsFixed(3)} miles',
                                  style: SportperStyle.baseStyle.copyWith(
                                      color: Colors.white, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                Container(
                  color: Color(0xFFBEFFF2),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Row(
                      //   children: [
                      //     Image.asset(
                      //       ImagePaths.icHostBy,
                      //       width: 40,
                      //       height: 40,
                      //     ),
                      //     SizedBox(
                      //       width: 8,
                      //     ),
                      //     Expanded(
                      //       child: RichText(
                      //         maxLines: 2,
                      //         overflow: TextOverflow.ellipsis,
                      //         text: TextSpan(
                      //           text: Strings.hostedBy,
                      //           style: SportperStyle.baseStyle.copyWith(fontSize: 13),
                      //           children: [
                      //             TextSpan(
                      //                 text: vm.game.host.fullName,
                      //                 style: SportperStyle.boldStyle.copyWith(fontSize: 13)),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 16,
                      // ),
                      Text(
                        '${Strings.address}: ${vm.game.course.address}',
                          style: SportperStyle.baseStyle.copyWith(fontSize: 13)
                      ),
                      SizedBox(height: 5,),
                      Text(
                        '${Strings.joined}:',
                        style: SportperStyle.baseStyle.copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      ...vm.game.usersJoined
                          .map((e) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    AvatarCircle(size: 30, url: e.avatar),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${e.fullText}',
                                        style: SportperStyle.baseStyle
                                            .copyWith(fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //         child: AvatarListWidget(
                      //             avatarList: vm.game.usersJoined
                      //                 .map((e) => e.avatar)
                      //                 .toList())),
                      //     SizedBox(width: 20,),
                      //     Text(
                      //       '${vm.joinText} ${Strings.joined}',
                      //       style: SportperStyle.baseStyle.copyWith(fontSize: 13),
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${vm.getAttributeText}',
                        textAlign: TextAlign.center,
                        style: SportperStyle.baseStyle.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
