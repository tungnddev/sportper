import 'package:sportper/utils/definded/strings.dart';

class GamePlayer {
  String avatar;
  String id;
  String fullName;
  int handicap;
  int age;

  GamePlayer(this.avatar, this.id, this.fullName, this.handicap, this.age);

  String get fullText => '$fullName   ${Strings.handicap}: $handicap ${Strings.age}: $age';
}