import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {
  StorageService._privateConstructor();

  static final StorageService instance = StorageService._privateConstructor();

  Future<String> uploadAvatar(String localPath) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('user/profile/${basename(localPath)}');
    await storageReference.putFile(File(localPath));
    String url = await storageReference.getDownloadURL();
    return url;
  }

  Future<String> uploadImagePost(String localPath) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${basename(localPath)}');
    await storageReference.putFile(File(localPath));
    String url = await storageReference.getDownloadURL();
    return url;
  }
}
