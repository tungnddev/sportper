import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';

class EditProfileState {

}

class EditProfileStateInitial extends EditProfileState {

}

class EditProfileStateShowLoading extends EditProfileState {

}

class EditProfileStateHideLoading extends EditProfileState {

}

class EditProfileStateFailed extends EditProfileState {
  Object error;
  EditProfileStateFailed(this.error);
}

class EditProfileStateSuccess extends EditProfileState {
  SportperUserVM vm;
  EditProfileStateSuccess(this.vm);
}
