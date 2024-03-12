import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/other_user/get_other_user_recommendation_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_recommendation/other_recommendation_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_recommendation/other_recommendation_state.dart';

class OtherRecommendationBloc
    extends Bloc<OtherRecommendationEvent, OtherRecommendationState> {
  final GetOtherUserRecommendationUseCase getOtherUserRecommendationUseCase;
  OtherRecommendationBloc({required this.getOtherUserRecommendationUseCase})
      : super(OtherRecommendationInitial()) {
    on<GetOtherRecommendation>(_getOtherRecommendations);
  }
  void _getOtherRecommendations(GetOtherRecommendation event, emit) async {
    if (event.page == 1) {
      emit(OtherRecommendationLoading());
      final result = await getOtherUserRecommendationUseCase(
          GetOtherUserRecommendationParams(id: event.id, page: event.page));

      result.fold((error) {
        emit(OtherRecommendationFailed());
      }, (recommendations) {
        emit(OtherRecommendationSuccess(
            recommendations: recommendations,
            page: event.page,
            hasReachedMax: false));
      });
    } else {
      emit(OtherRecommendationNextLoading(
        recommendations: event.recommendations,
      ));
      final result = await getOtherUserRecommendationUseCase(
          GetOtherUserRecommendationParams(id: event.id, page: event.page));
      result.fold((error) {
        emit(OtherRecommendationSuccess(
            hasReachedMax: false,
            recommendations: event.recommendations,
            page: event.page - 1));
      }, (recommendations) {
        if (recommendations.isEmpty) {
          emit(OtherRecommendationSuccess(
              hasReachedMax: true,
              recommendations: event.recommendations,
              page: event.page - 1));
        } else {
          emit(OtherRecommendationSuccess(
              recommendations: [...event.recommendations, ...recommendations],
              hasReachedMax: false,
              page: event.page));
        }
      });
    }
  }
}
