class StartState {

}

class StartInitial extends StartState {

}

class StartOpenHome extends StartState {

}

class StartLoading extends StartState {

}

class StartHideLoading extends StartState {

}

class StartLoginFail extends StartState {
  Object e;
  StartLoginFail(this.e);
}