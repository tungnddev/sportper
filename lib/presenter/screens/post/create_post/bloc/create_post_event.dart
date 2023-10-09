class CreatePostEvent {

}

class CreatePostStart extends CreatePostEvent{
  String content;
  String? image;

  CreatePostStart(this.content, this.image);
}