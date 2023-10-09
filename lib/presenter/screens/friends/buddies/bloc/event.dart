class BuddiesEvent {

}

class BuddiesFetch extends BuddiesEvent {
  BuddiesFetch();
}

class BuddiesLoadMore extends BuddiesEvent {
  BuddiesLoadMore();
}

class BuddiesAddNewFriend extends BuddiesEvent {
  String name;
  String phone;
  BuddiesAddNewFriend(this.name, this.phone);
}

class BuddiesDeleteFriend extends BuddiesEvent {
  String id;
  BuddiesDeleteFriend(this.id);
}