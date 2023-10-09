import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/image_picker.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileAvatarWidget extends StatefulWidget {
  final String oldAvatar;
  final Function(String newLocalPath) onChangeAvatar;

  const EditProfileAvatarWidget(
      {Key? key, required this.oldAvatar, required this.onChangeAvatar})
      : super(key: key);

  @override
  _EditProfileAvatarWidgetState createState() =>
      _EditProfileAvatarWidgetState();
}

class _EditProfileAvatarWidgetState extends State<EditProfileAvatarWidget> {
  String? _newImagePathLocal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _changeAvatar();
          },
          child: _newImagePathLocal == null
              ? AvatarCircle(
                  size: getProportionateScreenWidth(300), url: widget.oldAvatar)
              : ImageFileCircle(
                  size: getProportionateScreenWidth(300),
                  path: _newImagePathLocal!,
                ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        GestureDetector(
          onTap: () {
            _changeAvatar();
          },
          child: Text(
            Strings.changeProfilePhoto,
            style: SportperStyle.baseStyle
                .copyWith(fontSize: 13, color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  _changeAvatar() async {
    String? newImagePath = await openImagePicker(context,
        ratio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    if (newImagePath != null) {
      setState(() {
        _newImagePathLocal = newImagePath;
      });
      widget.onChangeAvatar.call(newImagePath);
    }
  }
}
