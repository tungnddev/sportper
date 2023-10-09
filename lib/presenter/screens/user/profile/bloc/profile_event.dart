import 'package:sportper/presenter/models/sportper_user_vm.dart';

class ProfileEvent {
}

class ProfileEventStartLoad extends ProfileEvent {

}

class ProfileEventLogOut extends ProfileEvent {

}


class ProfileEventFillNewVM extends ProfileEvent {
  SportperUserVM vm;
  ProfileEventFillNewVM(this.vm);
}