class NewGameState {
  const NewGameState();
}

class NewGameInitial extends NewGameState {
  const NewGameInitial();
}

class NewGameSuccessful extends NewGameState {

}

class NewGameLoading extends NewGameState {

}

class NewGameHideLoading extends NewGameState {

}

class NewGameFailMessage extends NewGameState {
  String errorText;
  NewGameFailMessage(this.errorText);
}

class NewGameFail extends NewGameState {
  Object error;
  NewGameFail(this.error);
}
