import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/post_vm.dart';

class FeedState {

}


class FeedInitial extends FeedState {

}

class FeedLoading extends FeedState {
}

class FeedFetchSuccessful extends FeedState {
  final List<PostVM?> listFeeds;
  FeedFetchSuccessful({required this.listFeeds});
}

class FeedFetchFailed extends FeedState {
  final Object error;
  FeedFetchFailed({required this.error});
}

class FeedFetchEmpty extends FeedState {
}

class FeedShowLoading extends FeedState {
  bool isShowIndicator;
  FeedShowLoading({this.isShowIndicator = true});
}

class FeedHideLoading extends FeedState {

}


