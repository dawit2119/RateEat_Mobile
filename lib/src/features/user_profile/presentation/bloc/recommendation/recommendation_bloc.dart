import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/recommendation/recommendation_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/recommendation/recommendation_state.dart';

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final GetUserRecommendationUseCase getUserRecommendationUseCase;
  RecommendationBloc({required this.getUserRecommendationUseCase})
      : super(RecommendationInitial()) {
    on<GetMyRecommendations>(_getMyRecommendations);
  }
  void _getMyRecommendations(GetMyRecommendations event, emit) async {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    try {
      if (user == null) {
        emit(RecommendationFailed());
      } else {
        if (event.page == 1) {
          emit(RecommendationLoading());
        } else {
          emit(
            RecommendationNextLoading(
              recommendations: event.recommendations,
            ),
          );
        }
        final result = await getUserRecommendationUseCase(event.page);
        List<UserRecommendation>? localRecommendations;
        if (result.isLeft()) {
          localRecommendations =
              dpLocator<LocalProfileDataProvider>().getUserRecommendations();
        } else {
          localRecommendations = null;
        }

        result.fold(
          (error) {
            if (event.page == 1) {
              if (localRecommendations == null) {
                throw Exception("failed to load recommendations");
              } else {
                emit(
                  RecommendationSuccess(
                      isLocalData: true,
                      recommendations: localRecommendations,
                      hasReachedMax: true,
                      page: event.page - 1),
                );
              }
            } else {
              emit(
                RecommendationSuccess(
                    isLocalData: false,
                    hasReachedMax: false,
                    recommendations: event.recommendations,
                    page: event.page - 1),
              );
            }
          },
          (recommendations) {
            try {
              dpLocator<LocalProfileDataProvider>().cacheUserRecommendations(
                [...event.recommendations, ...recommendations],
              );
            } catch (e) {
              //failed to cache
            }
            if (recommendations.isEmpty) {
              emit(
                RecommendationSuccess(
                    isLocalData: false,
                    hasReachedMax: true,
                    recommendations: event.recommendations,
                    page: event.page - 1),
              );
            } else {
              emit(
                RecommendationSuccess(
                    isLocalData: false,
                    recommendations: [
                      ...event.recommendations,
                      ...recommendations
                    ],
                    hasReachedMax: false,
                    page: event.page),
              );
            }
          },
        );
      }
    } catch (e) {
      emit(RecommendationFailed());
    }
  }
}
