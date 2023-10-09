import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/filter_post.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/post_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/post_vm.dart';
import 'package:sportper/presenter/screens/post/feed/feed_page.dart';
import 'package:sportper/utils/definded/const.dart';

import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  static const int LIMIT = 10;
  List<PostVM?> currentListContent = [];
  late bool canLoadMore;

  PostRepository repository;
  UserRepository userRepository;
  AuthRepository authRepository;

  Map<String, dynamic>? lastDocData;

  FilterPost currentFilter = FilterPost(type: PostTypeConst.CONTENT);

  ContentBloc(this.repository, this.userRepository, this.authRepository) : super(ContentInitial());


  List<String> currentListFriend = [];

  @override
  Stream<ContentState> mapEventToState(ContentEvent event) async* {
    if (event is ContentFetch) {
      currentListContent = [];
      lastDocData = null;
      canLoadMore = true;
      yield ContentLoading();
      yield* fetchPost();
    } else if (event is ContentLoadMore) {
      if (!canLoadMore) return;
      currentListContent.add(null);
      yield ContentFetchSuccessful(listContents: currentListContent);
      yield* fetchPost(isLoadMore: true);
    } else if (event is ContentChangeFavourite) {
      yield* changeFavourite(event.id);
    } else if (event is ContentChangeFavouriteFromDetail) {
      yield* changeFavouriteFromDetail(event.id, event.value);
    } else if (event is ContentChangeNumLikeFromDetail) {
      yield* changeNumLikesFromDetail(event.id, event.value);
    } else if (event is ContentChangeNumCommentsFromDetail) {
      yield* changeNumCommentsFromDetail(event.id, event.value);
    }
  }

  Stream<ContentState> fetchPost({bool isLoadMore = false}) async* {
    try {

      String userId = (await authRepository.currentUser())?.uid ?? '';

      final data =
          await repository.getList(LIMIT, lastDocData, currentFilter);
      List<Post> posts = data.first;
      lastDocData = data.second;
      canLoadMore = posts.length >= LIMIT;
      if (isLoadMore) {
        currentListContent.removeLast();
      }
      currentListContent.addAll(posts
          .map((e) => PostVM(e, e.likeList.contains(userId), e.likeList.length))
          .toList());
      if (currentListContent.isEmpty) {
        yield ContentFetchEmpty();
      } else {
        yield ContentFetchSuccessful(
          listContents: currentListContent,
        );
      }
    } catch (error) {
      yield ContentFetchFailed(error: error);
    }
  }

  Stream<ContentState> changeFavourite(String id) async* {
    try {
      final item = currentListContent
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null) return;
      yield ContentShowLoading(isShowIndicator: false);
      await repository.changeLikePost(id, like: !item.isLiked);
      if (item.isLiked) {
        item.likeCount--;
        item.isLiked = false;
      } else {
        item.likeCount++;
        item.isLiked = true;
      }
      yield ContentHideLoading();
      yield ContentFetchSuccessful(
        listContents: currentListContent,
      );
    } catch (error) {
      yield ContentHideLoading();
      yield ContentFetchFailed(error: error);
    }
  }

  Stream<ContentState> changeFavouriteFromDetail(String id, bool value) async* {
    try {
      final item = currentListContent
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null || item.isLiked == value) return;
      item.isLiked = value;
      yield ContentFetchSuccessful(
        listContents: currentListContent,
      );
    } catch (error) {
      yield ContentFetchFailed(error: error);
    }
  }

  Stream<ContentState> changeNumLikesFromDetail(String id, int value) async* {
    try {
      final item = currentListContent
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null || item.likeCount == value) return;
      item.likeCount = value;
      yield ContentFetchSuccessful(
        listContents: currentListContent,
      );
    } catch (error) {
      print(error);
    }
  }

  Stream<ContentState> changeNumCommentsFromDetail(String id, int value) async* {
    try {
      final item = currentListContent
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null || item.entity.commentCount == value) return;
      item.entity.commentCount = value;
      yield ContentFetchSuccessful(
        listContents: currentListContent,
      );
    } catch (error) {
      print(error);
    }
  }
}
