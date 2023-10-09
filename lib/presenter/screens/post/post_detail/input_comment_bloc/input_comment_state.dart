class InputCommentState {

}

class InputCommentInitial extends InputCommentState {

}

class InputCommentUploadLoading extends InputCommentState {

}

class InputCommentUploadImageSuccessfully extends InputCommentState {
  String url;
  InputCommentUploadImageSuccessfully(this.url);
}