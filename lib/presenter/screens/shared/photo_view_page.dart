import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {

  final String url;

  const PhotoViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SportperAppBar(),
            Expanded(child: PhotoView(
              imageProvider: CachedNetworkImageProvider(url),
            ))
          ],
        ),
      ),
    );
  }
}
