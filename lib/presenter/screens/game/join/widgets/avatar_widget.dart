import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/presenter/screens/game/join/avatarbloc/avatar_bloc.dart';
import 'package:sportper/presenter/screens/game/join/avatarbloc/avatar_event.dart';
import 'package:sportper/presenter/screens/game/join/avatarbloc/avatar_state.dart';
import 'package:sportper/utils/widgets/images.dart';

class AvatarWidget extends StatefulWidget {
  final Function()? onTap;
  const AvatarWidget({Key? key, this.onTap}) : super(key: key);

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  late AvatarBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(AvatarEventLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarBloc, AvatarState>(
        bloc: bloc,
        builder: (context, state) => GestureDetector(
          onTap: widget.onTap,
          child: AvatarCircle(
                size: 45,
                url: state is AvatarStateSuccessful ? state.avatar : '',
              ),
        ));
  }
}
