import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_case/use_cases.dart';
import './local_search_history_event.dart';
import './local_search_history_state.dart';

class LocalSearchHistoryBloc
    extends Bloc<LocalSearchHistoryEvent, LocalSearchHistoryState> {
  final AddLocalSearchHistoryUseCase addLocalSearchHistoryUseCase;
  final ClearLocalHistoryUseCase clearLocalHistoryUseCase;
  final DeleteLocalHistoryUseCase deleteLocalHistoryUseCase;
  final GetLocalHistoryUseCase getLocalHistoryUseCase;

  LocalSearchHistoryBloc({
    required this.addLocalSearchHistoryUseCase,
    required this.clearLocalHistoryUseCase,
    required this.deleteLocalHistoryUseCase,
    required this.getLocalHistoryUseCase,
  }) : super(LocalSearchHistoryInitialState()) {
    on<GetLocalSearchHistory>(_onGetLocalSearchHistory);
    on<AddLocalSearchHistory>(_onAddLocalSearchHistory);
    on<DeleteLocalSearchHistory>(_onDeleteLocalSearchHistory);
    on<ClearLocalSearchHistory>(_onClearLocalSearchHistory);
  }

  void _onGetLocalSearchHistory(GetLocalSearchHistory event,
      Emitter<LocalSearchHistoryState> emit) async {
    try {
      emit(
        LocalSearchHistoryActionLoading(),
      );
      var response = await getLocalHistoryUseCase(GetHistoryUseCaseParams(
        localSearchType: event.localSearchType,
      ));
      response.fold(
        (l) => emit(
          LocalSearchHistoryActionsFailed(
            message: "Unable to get search histories",
          ),
        ),
        (history) => emit(
          LocalSearchHistoryLoaded(
            histories: history,
          ),
        ),
      );
    } catch (e) {
      emit(
        LocalSearchHistoryActionsFailed(
            message: "Unable to get search histories"),
      );
    }
  }

  void _onAddLocalSearchHistory(AddLocalSearchHistory event,
      Emitter<LocalSearchHistoryState> emit) async {
    try {
      emit(
        LocalSearchHistoryActionLoading(),
      );
      var response =
          await addLocalSearchHistoryUseCase(AddLocalSearchUseCaseParams(
        history: event.history,
        localSearchType: event.localSearchType,
      ));
      response.fold(
        (l) => emit(
          LocalSearchHistoryActionsFailed(message: "Unable to  add history"),
        ),
        (history) => emit(
          LocalSearchHistoryActionsSuccess(
            message: "History added",
          ),
        ),
      );
    } catch (e) {
      emit(
        LocalSearchHistoryActionsFailed(message: "Unable to add history"),
      );
    }
  }

  void _onDeleteLocalSearchHistory(DeleteLocalSearchHistory event,
      Emitter<LocalSearchHistoryState> emit) async {
    try {
      emit(
        LocalSearchHistoryActionLoading(),
      );
      var response = await deleteLocalHistoryUseCase(
        DeleteHistoryUseCaseParams(
          id: event.id,
          localSearchType: event.localSearchType,
        ),
      );
      response.fold(
        (l) => emit(
          LocalSearchHistoryActionsFailed(message: "Unable to delete history"),
        ),
        (history) => emit(
          LocalSearchHistoryActionsSuccess(
            message: "History deleted",
          ),
        ),
      );
    } catch (e) {
      emit(
        LocalSearchHistoryActionsFailed(message: "Unable to delete history"),
      );
    }
  }

  void _onClearLocalSearchHistory(ClearLocalSearchHistory event,
      Emitter<LocalSearchHistoryState> emit) async {
    try {
      emit(
        LocalSearchHistoryActionLoading(),
      );
      var response = await clearLocalHistoryUseCase(
        ClearLocalHistoryUseCaseParams(
          localSearchType: event.localSearchType,
        ),
      );
      response.fold(
        (l) => emit(
          LocalSearchHistoryActionsFailed(message: "Unable to clear history"),
        ),
        (history) => emit(
          LocalSearchHistoryActionsSuccess(
            message: "History cleared",
          ),
        ),
      );
    } catch (e) {
      emit(
        LocalSearchHistoryActionsFailed(message: "Unable to clear histories"),
      );
    }
  }
}
