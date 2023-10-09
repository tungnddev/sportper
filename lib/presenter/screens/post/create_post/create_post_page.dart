import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/presenter/screens/post/create_post/bloc/create_post_bloc.dart';
import 'package:sportper/presenter/screens/post/create_post/bloc/create_post_state.dart';
import 'package:sportper/presenter/screens/post/create_post/widgets/create_post_image_widget.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';

import 'bloc/create_post_event.dart';

class CreatePostPage extends StatelessWidget {
  final PostType postType;

  const CreatePostPage({Key? key, required this.postType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => CreatePostBloc(RepositoryProvider.of(context),
              RepositoryProvider.of(context), RepositoryProvider.of(context), postType))
    ], child: CreatePostWidget());
  }
}

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({Key? key}) : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidget1State();
}

class _CreatePostWidget1State extends State<CreatePostWidget> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  String? currentImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              SportperAppBar(
                title: Strings.createPost,
              ),
              Expanded(
                child: BlocListener<CreatePostBloc, CreatePostState>(
                  listener: (context, state) {
                    if (state is CreatePostError) {
                      AppExceptionHandle.handle(context, state.error);
                    } else if (state is CreatePostShowLoading) {
                      LoadingDialog.show(context);
                    } else if (state is CreatePostHideLoading) {
                      Navigator.pop(context);
                    } else if (state is CreatePostSuccessfully) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(Strings.addPostSuccessful),
                        duration: Duration(seconds: 2),
                      ));
                      RxBusService().add(
                        RxBusName.REFRESH_FEED,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            maxLines: 3,
                            focusNode: _focusNode,
                            controller: _textEditingController,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorUtils.disableText)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorUtils.disableText)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              hintText: Strings.typeYourPost,
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CreatePostImageWidget(
                            onChange: (text) => currentImage = text,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: SportperButton(
                  text: Strings.addPost,
                  onPress: () {
                    if (_textEditingController.text.trim().isEmpty) {
                      return;
                    }
                    BlocProvider.of<CreatePostBloc>(context).add(
                        CreatePostStart(
                            _textEditingController.text.trim(), currentImage));
                  },
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
