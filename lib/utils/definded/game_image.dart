import 'dart:math';

class GameImageGenerate {
  static final List<String> dummyGameImageList = [
    'https://i.ibb.co/KVDd7Tp/image-14-1.png'
  ];

  static String get() {
    return dummyGameImageList[Random().nextInt(dummyGameImageList.length)];
  }
}