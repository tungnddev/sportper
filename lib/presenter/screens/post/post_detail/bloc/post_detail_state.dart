import 'package:sportper/presenter/models/post_detail_vm.dart';

class   PostDetailState {

}


class PostDetailInitial extends PostDetailState {

}

class PostDetailLoading extends PostDetailState {
}

class PostDetailFetchSuccessful extends PostDetailState {
  final PostDetailVM vm;
  PostDetailFetchSuccessful({required this.vm});
}

class PostDetailScrollToLastPosition extends PostDetailState {
  PostDetailScrollToLastPosition();
}

class PostDetailAddCommentSuccessful extends PostDetailState {
  PostDetailAddCommentSuccessful();
}

class PostDetailFetchFailed extends PostDetailState {
  final Object error;
  PostDetailFetchFailed({required this.error});
}

class PostDetailShowLoading extends PostDetailState {
  bool isShowIndicator;
  PostDetailShowLoading({this.isShowIndicator = true});
}

class PostDetailHideLoading extends PostDetailState {

}


