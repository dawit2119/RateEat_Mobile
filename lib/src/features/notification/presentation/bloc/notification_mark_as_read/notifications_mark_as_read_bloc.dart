import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/mark_notification_read_status.dart';

part 'notifications_mark_as_read_event.dart';
part 'notifications_mark_as_read_state.dart';

class NotificationsMarkAsReadBloc
    extends Bloc<NotificationsMarkAsReadEvent, NotificationsMarkAsReadState> {
  final MarkNotificationReadStatusUseCase markNotificationReadStatusUseCase;
  NotificationsMarkAsReadBloc({
    required this.markNotificationReadStatusUseCase,
  }) : super(NotificationInitial()) {
    on<MarkNotificationStatusAsRead>(_onMarkNotificationStatusAsRead);
  }
  void _onMarkNotificationStatusAsRead(MarkNotificationStatusAsRead event,
      Emitter<NotificationsMarkAsReadState> emit) async {
    try {
      emit(
        MarkNotificationAsReadLoading(),
      );
      var response = await markNotificationReadStatusUseCase(
        event.notificationId,
      );
      response.fold(
        (l) => emit(
          const MarkNotificationAsReadFailed(
              message: "Unable to mark notification as read"),
        ),
        (r) => emit(
          const MarkNotificationAsReadSuccess(
              message: "Mark notification success"),
        ),
      );
    } catch (e) {
      emit(
        const MarkNotificationAsReadFailed(
            message: "Unable to mark notification as read"),
      );
    }
  }
}
