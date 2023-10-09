import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/presenter/screens/home/bloc/home_event.dart';
import 'package:sportper/presenter/screens/home/bloc/home_state.dart';
import 'package:sportper/presenter/screens/shared/notification_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  NotificationRepository repository;

  HomeBloc(this.repository) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeEventScheduleGameNotification) {
      final schedulerGame = await repository.getAllScheduleNotificationGame();
      NotificationService.instance.cancelAll();
      schedulerGame.forEach((element) {
        NotificationService.instance.scheduleGameNotification('Sportper',
            'You have ${element.title} game in 10 minutes', element.createdAt, element.gameId);
      });
    }
  }
}
