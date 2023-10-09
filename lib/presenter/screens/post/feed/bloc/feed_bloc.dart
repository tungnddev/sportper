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

import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  static const int LIMIT = 10;
  List<PostVM?> currentListFeed = [];
  late bool canLoadMore;

  PostRepository repository;
  UserRepository userRepository;
  AuthRepository authRepository;
  FriendRepository friendRepository;

  Map<String, dynamic>? lastDocData;

  FilterPost currentFilter = FilterPost(type: PostTypeConst.FEED);

  FeedBloc(this.repository, this.userRepository, this.authRepository, this.friendRepository) : super(FeedInitial());

  FeedTab currentTab = FeedTab.explore;

  List<String> currentListFriend = [];

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is FeedFetch) {
      currentListFeed = [];
      lastDocData = null;
      canLoadMore = true;
      yield FeedLoading();
      yield* fetchPost();
    } else if (event is FeedLoadMore) {
      if (!canLoadMore) return;
      currentListFeed.add(null);
      yield FeedFetchSuccessful(listFeeds: currentListFeed);
      yield* fetchPost(isLoadMore: true);
    } else if (event is FeedChangeFavourite) {
      yield* changeFavourite(event.id);
    } else if (event is FeedChangeFavouriteFromDetail) {
      yield* changeFavouriteFromDetail(event.id, event.value);
    } else if (event is FeedChangeNumLikeFromDetail) {
      yield* changeNumLikesFromDetail(event.id, event.value);
    } else if (event is FeedChangeNumCommentsFromDetail) {
      yield* changeNumCommentsFromDetail(event.id, event.value);
    }
  }

  Stream<FeedState> fetchPost({bool isLoadMore = false}) async* {
    try {

      String userId = (await authRepository.currentUser())?.uid ?? '';

      switch (currentTab) {
        case FeedTab.explore:
          currentFilter = FilterPost(type: PostTypeConst.FEED);
          break;
        case FeedTab.friends:
          if (currentListFriend.isEmpty) {
            currentListFriend = (await friendRepository.getBuddiesExist()).map((e) => e.id).toList();
          }
          currentFilter = FilterPost(type: PostTypeConst.FEED, listUser: currentListFriend);
      }

      final data =
          await repository.getList(LIMIT, lastDocData, currentFilter);
      List<Post> posts = data.first;
      lastDocData = data.second;
      canLoadMore = posts.length >= LIMIT;
      if (isLoadMore) {
        currentListFeed.removeLast();
      }
      currentListFeed.addAll(posts
          .map((e) => PostVM(e, e.likeList.contains(userId), e.likeList.length))
          .toList());
      if (currentListFeed.isEmpty) {
        yield FeedFetchEmpty();
      } else {
        yield FeedFetchSuccessful(
          listFeeds: currentListFeed,
        );
      }
    } catch (error) {
      yield FeedFetchFailed(error: error);
    }
  }

  Stream<FeedState> changeFavourite(String id) async* {
    try {
      final item = currentListFeed
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null) return;
      yield FeedShowLoading(isShowIndicator: false);
      await repository.changeLikePost(id, like: !item.isLiked);
      if (item.isLiked) {
        item.likeCount--;
        item.isLiked = false;
      } else {
        item.likeCount++;
        item.isLiked = true;
      }
      yield FeedHideLoading();
      yield FeedFetchSuccessful(
        listFeeds: currentListFeed,
      );
    } catch (error) {
      yield FeedHideLoading();
      yield FeedFetchFailed(error: error);
    }
  }

  Stream<FeedState> changeFavouriteFromDetail(String id, bool value) async* {
    try {
      final item = currentListFeed
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null || item.isLiked == value) return;
      item.isLiked = value;
      yield FeedFetchSuccessful(
        listFeeds: currentListFeed,
      );
    } catch (error) {
      yield FeedFetchFailed(error: error);
    }
  }

  Stream<FeedState> changeNumLikesFromDetail(String id, int value) async* {
    try {
      final item = currentListFeed
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null || item.likeCount == value) return;
      item.likeCount = value;
      yield FeedFetchSuccessful(
        listFeeds: currentListFeed,
      );
    } catch (error) {
      print(error);
    }
  }

  Stream<FeedState> changeNumCommentsFromDetail(String id, int value) async* {
    try {
      final item = currentListFeed
          .firstWhere((element) => element?.entity.id == id, orElse: null);
      if (item == null || item.entity.commentCount == value) return;
      item.entity.commentCount = value;
      yield FeedFetchSuccessful(
        listFeeds: currentListFeed,
      );
    } catch (error) {
      print(error);
    }
  }
}
