class RoleState {

}

class RoleStateInitial extends RoleState {

}

class RoleStateSuccessful extends RoleState {
  bool canPostContent;
  RoleStateSuccessful(this.canPostContent);
}