import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/generated/l10n.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/bloc/dialog_add_friend_bloc.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/bloc/dialog_add_friend_state.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/masked_textinput_controller.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/dialog_add_friend_event.dart';

class DialogAddFriend extends StatelessWidget {
  const DialogAddFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            DialogAddFriendBloc(RepositoryProvider.of(context)),
        child: DialogAddFriendWidget());
  }
}

class DialogAddFriendWidget extends StatefulWidget {
  const DialogAddFriendWidget({Key? key}) : super(key: key);

  @override
  _DialogAddFriendState createState() => _DialogAddFriendState();
}

class _DialogAddFriendState extends State<DialogAddFriendWidget> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DialogAddFriendBloc>(context)
        .add(DialogAddFriendStartLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width - 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: BlocBuilder<DialogAddFriendBloc, DialogAddFriendState>(
            builder: (context, state) => _buildMainDialog(state),
          )),
    );
  }

  _buildMainDialog(DialogAddFriendState state) {
    if (state is DialogAddFriendLoading) {
      return SizedBox(height: 100, child: LoadingView());
    }
    if (state is DialogAddFriendLoadSuccess) {
      return FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Strings.addFriend,
              style: SportperStyle.boldStyle.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
            FormBuilderTextField(
              name: 'fullName',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: Strings.dataRequired)
              ]),
              decoration:
              SportperStyle.inputDecoration(Strings.fullName),
            ),
            SizedBox(
              height: 8,
            ),
            FormBuilderTypeAhead<SportperUser>(
                decoration: SportperStyle.inputDecoration(Strings.phoneNumber),
                name: 'phoneNumber',
                itemBuilder: (context, user) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AvatarCircle(size: 40, url: user.avatar),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                            child: Text(user.phoneNumber,
                                style: SportperStyle.mediumStyle))
                      ],
                    ),
                  );
                },
                valueTransformer: (value) => value?.phoneNumber,
                selectionToTextTransformer: (value) => value.phoneNumber,
                suggestionsCallback: (query) {
                  if (query.isNotEmpty) {
                    var lowercaseQuery = query.toLowerCase();
                    return state.users.where((continent) {
                      return continent.phoneNumber
                          .toLowerCase()
                          .contains(lowercaseQuery);
                    }).toList();
                  } else {
                    return [];
                  }
                },
                noItemsFoundBuilder: (context) => SizedBox()),
            // FormBuilderTextField(
            //   name: 'phoneNumber',
            //   // validator: FormBuilderValidators.compose([
            //   //   FormBuilderValidators.required(context,
            //   //       errorText: Strings.dataRequired)
            //   // ]),
            //   decoration: SportperStyle.inputDecoration(Strings.phoneNumber),
            //   keyboardType: TextInputType.phone,
            //   inputFormatters: [
            //     MaskTextInputFormatter(mask: '+1 (###) ###-####')
            //   ],
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            // ),
            SizedBox(
              height: 20,
            ),
            SportperButton(
              text: Strings.request,
              onPress: () {
                final currentState = _formKey.currentState;
                if (currentState == null) return;
                if (currentState.saveAndValidate() == true) {
                  String? name = currentState.value['fullName'];
                  String? phone = currentState.value['phoneNumber'];
                  if (name?.isNotEmpty == false && phone?.isNotEmpty == false)
                    return;
                  Navigator.pop(context, Pair(name ?? '', phone ?? ''));
                }
              },
            ),
          ],
        ),
      );
    }
    return Container(
      height: 100,
    );
  }
}
