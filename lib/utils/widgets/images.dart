import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/extensions/nullable.dart';
import 'package:sportper/utils/widgets/loading_image.dart';

import 'loading_view.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final double width, height;
  final double radiusAll;

  CacheImage(
      {required this.url,
      required this.height,
      required this.width,
      this.radiusAll = 0});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => LoadAnimation(
          child: Container(
        color: ColorUtils.grayBG,
        width: width,
        height: height,
      )),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radiusAll),
          color: ColorUtils.grayBG
        ),
        alignment: Alignment.center,
        child: Image.asset(
          ImagePaths.errorImage,
          width: width,
          height: width,
        ),
      ),
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radiusAll),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class AvatarCircle extends StatelessWidget {
  final double size;
  final String url;
  final Color colorBorder;
  final String defaultImage;
  final double widthBorder;
  final int sizeNetworkImage;
  final BoxFit fit;

  AvatarCircle(
      {required this.size,
      required this.url,
      this.colorBorder = const Color.fromRGBO(235, 235, 245, 1),
      this.defaultImage = ImagePaths.defaultAvatar,
      this.widthBorder = 1,
      this.sizeNetworkImage = 100,
      this.fit = BoxFit.fill});

  @override
  Widget build(BuildContext context) {
    return url.isNullOrEmpty
        ? ErrorImageCircle(size: size, errorImage: defaultImage)
        : CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => ClipOval(
              child: LoadAnimation(
                  child: Container(
                    color: ColorUtils.grayBG,
                    width: size,
                    height: size,
                  )),
            ),
            errorWidget: (context, url, error) => ErrorImageCircle(
              size: size,
              errorImage: defaultImage,
            ),
            imageBuilder: (context, imageProvider) => Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: colorBorder, width: widthBorder),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
          );
  }
}

class AvatarLoadingView extends StatelessWidget {
  final double size;

  AvatarLoadingView({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ColorUtils.grayBG,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      // child: LoadingView(
      //   size: size * 3 / 20,
      //   strokeWidth: size > 70 ? 2 : 1,
      // ),
    );
  }
}

class ErrorImageCircle extends StatelessWidget {
  final double size;
  final String errorImage;

  ErrorImageCircle({required this.size, required this.errorImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromRGBO(235, 235, 245, 1), width: 0.5),
          color: ColorUtils.grayBG,
          shape: BoxShape.circle,
          image:
              DecorationImage(image: AssetImage(errorImage), fit: BoxFit.fill)),
      alignment: Alignment.center,
    );
  }
}

class ImageFileCircle extends StatelessWidget {
  final double size;
  final String path;

  ImageFileCircle({required this.size, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromRGBO(235, 235, 245, 1), width: 0.5),
          color: ColorUtils.grayBG,
          shape: BoxShape.circle,
          image:
          DecorationImage(image: FileImage(File(path)), fit: BoxFit.fill)),
      alignment: Alignment.center,
    );
  }
}
