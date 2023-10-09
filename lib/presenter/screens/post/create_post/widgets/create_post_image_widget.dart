import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/image_picker.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class CreatePostImageWidget extends StatefulWidget {

  final Function(String? image)? onChange;

  const CreatePostImageWidget({Key? key, this.onChange}) : super(key: key);

  @override
  State<CreatePostImageWidget> createState() => _CreatePostImageWidgetState();
}

class _CreatePostImageWidgetState extends State<CreatePostImageWidget> {
  String? currentImage;


  @override
  Widget build(BuildContext context) {
    if (currentImage == null) {
      return GestureDetector(
        onTap: () async {
          final imagePath = await openImagePicker(context);
          if (imagePath != null) {
            widget.onChange?.call(imagePath);
            setState(() {
              currentImage = imagePath;
            });
          }
        },
        child: Column(
          children: [
            Image.asset(ImagePaths.addImage, width: 40, height: 40, color: Theme
                .of(context)
                .primaryColor,),
            SizedBox(width: 4,),
            Text(
              Strings.addImage,
              style: SportperStyle.semiBoldStyle.copyWith(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 17),
            )
          ],
        ),
      );
    }
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Image.file(
            File(currentImage!),
            fit: BoxFit.fitWidth
          ),
        ),
        GestureDetector(
            onTap: () {
              widget.onChange?.call(null);
              setState(() {
                currentImage = null;
              });
            },
            child: Image.asset(
              ImagePaths.icDeleteImage,
              width: 30,
              height: 30,
            ))
      ],
    );
  }
}
