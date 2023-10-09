import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'gesture_detector.dart';
import 'text_style.dart';

Future<String?> openImagePicker(BuildContext context, {CropAspectRatio? ratio, List<CropAspectRatioPreset>? aspectRatioPresets}) {
  return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    Strings.selectSource,
                    style: SportperStyle.boldStyle.copyWith(fontSize: 18),
                  )),
              RippleInkWell(
                onTap: () async {
                  final pickFile = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      maxHeight: 1080,
                      maxWidth: 1080,
                      imageQuality: 80);
                  if (pickFile != null) {
                    final croppedFile = await _cropFile(pickFile.path, ratio: ratio, aspectRatioPresets: aspectRatioPresets);
                    Navigator.pop(context, croppedFile?.path);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                  child: Text(
                    Strings.useCamera,
                    style: SportperStyle.baseStyle,
                  ),
                ),
              ),
              Container(
                color: Color.fromRGBO(236, 236, 236, 1),
                height: 1,
              ),
              RippleInkWell(
                onTap: () async {
                  final pickFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 1080,
                      maxWidth: 1080,
                      imageQuality: 80);
                  if (pickFile != null) {
                    final croppedFile = await _cropFile(pickFile.path, ratio: ratio, aspectRatioPresets: aspectRatioPresets);
                    Navigator.pop(context, croppedFile?.path);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                  child: Text(
                    Strings.useGallery,
                    style: SportperStyle.baseStyle,
                  ),
                ),
              )
            ],
          ),
        );
      });
}

Future<File?> _cropFile(String path, {CropAspectRatio? ratio, List<CropAspectRatioPreset>? aspectRatioPresets}) async {
  return ImageCropper().cropImage(
      compressQuality: 80,
      maxHeight: 1080,
      maxWidth: 1080,
      sourcePath: path,
      aspectRatio: ratio,
      aspectRatioPresets: aspectRatioPresets ?? [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Sportper',
        toolbarColor: ColorUtils.green,
        toolbarWidgetColor: Colors.white,
        hideBottomControls: false,
        initAspectRatio: CropAspectRatioPreset.square,
      ),
      iosUiSettings: IOSUiSettings(
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioLockDimensionSwapEnabled: true,
          rotateButtonsHidden: false,
          minimumAspectRatio: 1.0,
          title: 'Sportper'));
}
