class NewGameEvent {

}

class NewGameStartNewGame extends NewGameEvent {
  final Map<String, dynamic> data;
  NewGameStartNewGame(this.data);
}