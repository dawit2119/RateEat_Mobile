import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/notification.dart';
import '../../../domain/use_cases/get_user_notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetUserNotificationsUseCase getUserNotificationsUseCase;
  NotificationsBloc({
    required this.getUserNotificationsUseCase,
  }) : super(NotificationInitial()) {
    on<GetUserNotifications>(_onGetNotifications);
    on<UpdateNotificationReadStatusLocally>(_markNotificationAsReadLocally);
  }

  void _onGetNotifications(
      GetUserNotifications event, Emitter<NotificationsState> emit) async {
    Map<String, List<NotificationEntity>> previouslyLoadedNotifications =
        (state is NotificationsLoaded)
            ? (state as NotificationsLoaded).notifications
            : {};
    if (event.page == 1) {
      emit(
        NotificationsLoading(),
      );
    } else {
      emit(
        NotificationsNextLoading(
          notifications: previouslyLoadedNotifications,
        ),
      );
    }

    try {
      var response = await getUserNotificationsUseCase(
        GetUserNotificationsUseCaseParams(
          userId: event.userId,
          limit: 20,
          page: event.page,
        ),
      );
      response.fold(
        (l) => {
          if (event.page == 1)
            {
              emit(
                const NotificationActionsFailed(
                  message: "Unable to fetch notifications",
                ),
              ),
            }
          else
            emit(
              NotificationsLoaded(
                notifications: previouslyLoadedNotifications,
                fetchingStatus: false,
              ),
            ),
        },
        (notifications) {
          Map<String, List<NotificationEntity>> groupedNotifications = {};
          for (var notification in notifications) {
            String formattedDate =
                DateFormat('yyyy-MM-dd').format(notification.createdAt);
            if (!groupedNotifications.containsKey(formattedDate)) {
              groupedNotifications[formattedDate] = [];
            }
            groupedNotifications[formattedDate]?.add(notification);
          }
          if (event.page == 1) {
            emit(
              NotificationsLoaded(
                notifications: groupedNotifications,
                hasReachedMax: groupedNotifications.isEmpty,
              ),
            );
          } else {
            groupedNotifications.forEach((key, value) {
              if (previouslyLoadedNotifications.containsKey(key)) {
                previouslyLoadedNotifications[key]?.addAll(value);
              } else {
                previouslyLoadedNotifications[key] = value;
              }
            });
            emit(
              NotificationsLoaded(
                notifications: previouslyLoadedNotifications,
                hasReachedMax: groupedNotifications.isEmpty,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        const NotificationActionsFailed(
          message: "Unable to fetch notifications",
        ),
      );
    }
  }

  void _markNotificationAsReadLocally(
      UpdateNotificationReadStatusLocally event, emit) {
    final Map<String, List<NotificationEntity>> updatedNotificationsMap =
        event.notifications;

    List<NotificationEntity>? notificationsForDate =
        updatedNotificationsMap[event.key];
    emit(
      NotificationsLoading(),
    );
    if (notificationsForDate != null) {
      updatedNotificationsMap[event.key] =
          notificationsForDate.map((notification) {
        if (notification.id == event.notificationId) {
          return notification.copyWith(readStatus: true);
        }
        return notification;
      }).toList();
      emit(
        NotificationsLoaded(
          notifications: updatedNotificationsMap,
        ),
      );
    }
  }
}
