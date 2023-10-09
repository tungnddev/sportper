import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/post_vm.dart';

class ContentState {

}


class ContentInitial extends ContentState {

}

class ContentLoading extends ContentState {
}

class ContentFetchSuccessful extends ContentState {
  final List<PostVM?> listContents;
  ContentFetchSuccessful({required this.listContents});
}

class ContentFetchFailed extends ContentState {
  final Object error;
  ContentFetchFailed({required this.error});
}

class ContentFetchEmpty extends ContentState {
}

class ContentShowLoading extends ContentState {
  bool isShowIndicator;
  ContentShowLoading({this.isShowIndicator = true});
}

class ContentHideLoading extends ContentState {

}


