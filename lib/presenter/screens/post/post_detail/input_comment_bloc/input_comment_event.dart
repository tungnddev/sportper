class InputCommentEvent {

}

class UploadImageEvent extends InputCommentEvent {
  String imagePath;
  UploadImageEvent(this.imagePath);
}