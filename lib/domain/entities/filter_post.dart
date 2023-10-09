import 'package:sportper/utils/definded/const.dart';

class FilterPost {
  List<String>? listUser;
  String type;

  FilterPost({this.type = PostTypeConst.FEED, this.listUser});

  bool get hasFilter => listUser != null;
}