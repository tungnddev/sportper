import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';

class ConfirmationState {

}


class ConfirmationInitial extends ConfirmationState {

}

class ConfirmationLoading extends ConfirmationState {
}

class ConfirmationFetchFailed extends ConfirmationState {
  final Object error;
  ConfirmationFetchFailed({required this.error});
}

class ConfirmationShowLoading extends ConfirmationState {

}

class ConfirmationHideLoading extends ConfirmationState {

}

class ConfirmationJoinSuccessful extends ConfirmationState {

}


