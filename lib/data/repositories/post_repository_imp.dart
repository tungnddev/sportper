import 'package:sportper/data/remote/mapper/post_mapper.dart';
import 'package:sportper/data/remote/services/auth_service.dart';
import 'package:sportper/data/remote/services/post_service.dart';
import 'package:sportper/data/remote/services/user_service.dart';
import 'package:sportper/domain/entities/comment.dart';
import 'package:sportper/domain/entities/filter_post.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/domain/entities/reply.dart';
import 'package:sportper/domain/repositories/post_repository.dart';
import 'package:sportper/utils/pair.dart';

class PostRepositoryImp extends PostRepository {
  PostRepositoryImp._privateConstructor();

  static final PostRepository instance =
  PostRepositoryImp._privateConstructor();

  PostService _service = PostService.instance;
  AuthService _authService = AuthService.instance;
  UserService _userService = UserService.instance;

  PostMapper mapper = PostMapper();

  @override
  Future<String> createPost(Post post) {
    return _service.addPost(mapper.reMapPost(post));
  }

  @override
  Future<Post> getDetail(String id) async {
    final postModel = await _service.getAPost(id);
    return mapper.mapPost(postModel);
  }

  @override
  Future<Pair<List<Post>, Map<String, dynamic>?>> getList(int limit, Map<String, dynamic>? lastDocData, FilterPost filterPost) async {
    final data = await _service.getList(limit, lastDocData, filterPost);
    final List<Post> listPostResult = data.first.map((e) => mapper.mapPost(e)).toList();
    return Pair(listPostResult, data.second);
  }

  @override
  Future changeLikePost(String id, {bool like = true}) async {
    final user = await _authService.currentUser();
    if (user != null) {
      return _service.changeLikePost(id, user.uid, like: like);
    }
  }

  @override
  Future changeLikeComment(String postId, String commentId, {bool like = true}) async {
    final user = await _authService.currentUser();
    if (user != null) {
      return _service.changeLikeComment(postId, commentId, user.uid, like: like);
    }
  }

  @override
  Future changeLikeReply(String postId, String commentId, String replyId, {bool like = true}) async {
    final user = await _authService.currentUser();
    if (user != null) {
      return _service.changeLikeReply(postId, commentId, replyId, user.uid, like: like);
    }
  }

  @override
  Future<String> addComment(String postId, Comment comment) async {
    final commentModel = mapper.reMapComment(comment);
    return _service.addComment(postId, commentModel);

  }

  @override
  Future<String> addReply(String postId, String commentId, Reply reply) async {
    final replyModel = mapper.reMapReply(reply);
    return _service.addReply(postId, commentId, replyModel);
  }
}