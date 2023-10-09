import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/repositories/storate_repository.dart';
import 'package:sportper/presenter/screens/post/post_detail/input_comment_bloc/input_comment_event.dart';
import 'package:sportper/presenter/screens/post/post_detail/input_comment_bloc/input_comment_state.dart';

class InputCommentBloc extends Bloc<InputCommentEvent, InputCommentState> {

  StorageRepository storageRepository;

  InputCommentBloc(this.storageRepository) : super(InputCommentInitial());

  @override
  Stream<InputCommentState> mapEventToState(InputCommentEvent event) async* {
    if (event is UploadImageEvent) {
      yield InputCommentUploadLoading();
      String url = await storageRepository.uploadImagePost(event.imagePath);
      yield InputCommentUploadImageSuccessfully(url);
    }
  }

}