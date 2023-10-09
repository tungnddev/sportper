import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';

class ConfirmationEvent {

}

class ConfirmationJoin extends ConfirmationEvent {
  GameDetailVM gameDetailVM;
  ConfirmationJoin(this.gameDetailVM);
}
