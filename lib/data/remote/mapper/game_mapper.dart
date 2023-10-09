import 'package:sportper/data/models/course_model.dart';
import 'package:sportper/data/models/game_model.dart';
import 'package:sportper/data/models/user_model.dart';
import 'package:sportper/data/remote/mapper/course_mapper.dart';
import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/game_player.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/extensions/date.dart';

class GameMapper {
  GameMapper._privateConstructor();

  static final GameMapper _instance = GameMapper._privateConstructor();

  factory GameMapper() {
    return _instance;
  }

  DateTime _defaultDate = DateTime(1970);

  Game mapGame(GameModel? model, List<UserModel> users) {
    return Game(
        model?.id ?? "",
        model?.title ?? '',
        model?.subTitle ?? '',
        model?.image ?? '',
        model?.isBooked ?? false,
        model?.isTournament ?? false,
        model?.type ?? '',
        CourseMapper().mapCourse(model?.course),
        model?.numPlayers ?? 0,
        model?.numGuests ?? 0,
        users.map((e) => _mapPlayer(e)).toList(),
        model?.createdBy ?? '',
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        DateTime.tryParse(model?.time ?? '')?.toLocal() ?? _defaultDate,
        model?.smoke ?? false,
        model?.gamble ?? false,
        model?.drink ?? false,
        model?.minHandicap ?? 0,
        model?.maxHandicap ?? 0,
        _mapHost(model?.host));
  }

  GamePlayer _mapPlayer(UserModel userModel) {
    int age = DateTime.tryParse(userModel.birthday ?? '')?.age ?? 0;
    return GamePlayer(userModel.avatar ?? '', userModel.id ?? '',
        userModel.fullName ?? '', userModel.handicap ?? 0, age);
  }

  GameHost _mapHost(GameHostedModel? model) {
    return GameHost(model?.id ?? "", model?.fullName ?? '', model?.avatar ?? '',
        model?.phoneNumber ?? '', model?.handicap ?? 0, model?.age ?? 0);
  }

  GameHostedModel _reMapHost(GameHost model) {
    return GameHostedModel(model.id, model.fullName, model.avatar,
        model.phoneNumber, model.handicap, model.age);
  }

  GameModel remapGameModel(Game model, {bool isIncludeId = false}) {
    return GameModel(
        id: isIncludeId ? model.id : null,
        title: model.title,
        subTitle: model.subTitle,
        image: model.image,
        isBooked: model.isBooked,
        isTournament: model.isTournament,
        type: model.type,
        course: CourseMapper().remapCourse(model.course, isIncludeId: true),
        numPlayers: model.numPlayers,
        numGuests: model.numGuests,
        usersJoined: model.usersJoined.map((e) => e.id).toList(),
        createdAt: model.createdAt.toUtc().toIso8601String(),
        time: model.time.toUtc().toIso8601String(),
        createdBy: model.createdBy,
        smoke: model.smoke,
        gamble: model.gamble,
        drink: model.drink,
        minHandicap: model.minHandicap,
        maxHandicap: model.maxHandicap,
        host: _reMapHost(model.host));
  }
}
