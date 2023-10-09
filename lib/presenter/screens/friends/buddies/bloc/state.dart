import 'package:sportper/presenter/models/friend_vm.dart';

class BuddiesState {

}


class BuddiesInitial extends BuddiesState {

}

class BuddiesLoading extends BuddiesState {
}

class BuddiesFetchSuccessful extends BuddiesState {
  final List<FriendVM?> listVM;
  BuddiesFetchSuccessful({required this.listVM});
}

class BuddiesFetchFailed extends BuddiesState {
  final Object error;
  BuddiesFetchFailed({required this.error});
}

class BuddiesFetchEmpty extends BuddiesState {
}

class BuddiesShowLoading extends BuddiesState {

}

class BuddiesHideLoading extends BuddiesState {

}

class BuddiesAddBuddiesSuccessful extends BuddiesState {

}

class BuddiesDeleteBuddiesSuccessful extends BuddiesState {

}


