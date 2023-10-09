import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';

class ProfileState {

}

class ProfileStateInitial extends ProfileState {

}

class ProfileStateLoading extends ProfileState {

}

class ProfileStateFetch extends ProfileState {
  SportperUserVM vm;
  bool canEdit;
  ProfileStateFetch(this.vm, {required this.canEdit});
}

class ProfileStateShowLoading extends ProfileState {

}

class ProfileStateHideLoading extends ProfileState {

}

class ProfileStateLogOutSuccessful extends ProfileState {

}

class ProfileStateFailed extends ProfileState {
  Object error;
  ProfileStateFailed(this.error);
}
