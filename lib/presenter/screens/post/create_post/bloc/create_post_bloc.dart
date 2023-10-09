import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/domain/repositories/post_repository.dart';
import 'package:sportper/domain/repositories/storate_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/screens/post/create_post/bloc/create_post_event.dart';
import 'package:sportper/presenter/screens/post/create_post/bloc/create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository repository;
  final UserRepository userRepository;
  final StorageRepository storageRepository;
  final PostType postType;

  CreatePostBloc(this.repository, this.userRepository, this.storageRepository, this.postType) : super(CreatePostInitial());

  @override
  Stream<CreatePostState> mapEventToState(CreatePostEvent event) async* {
    if (event is CreatePostStart) {
      try {
        yield CreatePostShowLoading();
        final currentUser = await userRepository.getCurrentUser();
        if (currentUser == null) return;
        String? imageUrl;
        if (event.image != null) {
          imageUrl = await storageRepository.uploadImagePost(event.image!);
        }
        final post = Post.fromLocal(event.content, imageUrl, currentUser, postType);
        await repository.createPost(post);
        yield CreatePostHideLoading();
        yield CreatePostSuccessfully();
      } catch (e) {
        yield CreatePostHideLoading();
        yield CreatePostError(error: e);
      }
    }
  }
}
