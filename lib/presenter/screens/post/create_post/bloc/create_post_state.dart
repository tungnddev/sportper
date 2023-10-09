class CreatePostState {

}

class CreatePostInitial extends CreatePostState{

}

class CreatePostSuccessfully extends CreatePostState {

}

class CreatePostError extends CreatePostState {
  final Object error;
  CreatePostError({required this.error});
}

class CreatePostShowLoading extends CreatePostState {

}

class CreatePostHideLoading extends CreatePostState {

}