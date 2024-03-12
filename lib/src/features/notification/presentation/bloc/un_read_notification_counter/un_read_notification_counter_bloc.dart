import 'package:equatable/equatable.dart';
import '../../../domain/use_cases/get_un_read_notifications_count_use_case.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'un_read_notification_counter_state.dart';
part 'un_read_notification_counter_event.dart';

class UnreadNotificationsCounterBloc extends Bloc<
    UnreadNotificationsCounterEvent, UnreadNotificationsCounterState> {
  final GetUnreadNotificationsCountUseCase getUnReadNotificationsCountUseCase;
  UnreadNotificationsCounterBloc({
    required this.getUnReadNotificationsCountUseCase,
  }) : super(
          UnreadNotificationsCounterLoading(),
        ) {
    on<GetUnreadNotificationsCount>(_onGetReadNotificationsCount);
  }
  void _onGetReadNotificationsCount(
      GetUnreadNotificationsCount event, emit) async {
    emit(
      UnreadNotificationsCounterLoading(),
    );
    try {
      final response = await getUnReadNotificationsCountUseCase(
        event.userId,
      );
      response.fold(
        (l) => emit(
          UnreadNotificationsCounterFetchingFailed(),
        ),
        (unreadNotificationsCount) => emit(
          UnreadNotificationsCounterFetched(count: unreadNotificationsCount),
        ),
      );
    } catch (e) {
      emit(
        UnreadNotificationsCounterFetchingFailed(),
      );
    }
  }
}
