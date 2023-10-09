class GameDetailOverviewEvent {

}

class GameDetailOverviewFetch extends GameDetailOverviewEvent {
  GameDetailOverviewFetch();
}

class GameDetailJoin extends GameDetailOverviewEvent {

}

class GameDetailOverviewChangeFavourite extends GameDetailOverviewEvent {
  String id;
  GameDetailOverviewChangeFavourite(this.id);
}

class GameDetailOverviewAccept extends GameDetailOverviewEvent {
  GameDetailOverviewAccept();
}

class GameDetailOverviewDecline extends GameDetailOverviewEvent {
  GameDetailOverviewDecline();
}

class GameDetailOverviewDeletePlayer extends GameDetailOverviewEvent {
  String userId;

  GameDetailOverviewDeletePlayer(this.userId);
}
