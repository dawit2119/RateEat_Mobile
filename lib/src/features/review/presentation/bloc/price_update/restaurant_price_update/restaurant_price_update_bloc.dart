import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_update_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_state.dart';

class PriceUpdateBloc extends Bloc<PriceReviewEvent, PriceChangeState> {
  final PriceReviewUsecase priceReviewUsecase;
  PriceUpdateBloc({required this.priceReviewUsecase})
      : super(PriceChangeInitial()) {
    on<PriceChangeRequestEvent>(
      (event, emit) async {
        emit(PriceChangeLoading());
        final response = await priceReviewUsecase(
          PriceReviewUseCaseParams(
            priceReviewRequestModel: event.priceReviewRequestModel,
          ),
        );
        response.fold((failure) {
          emit(PriceChangeError(error: failure.errorMessage));
        }, (message) {
          emit(PriceChangeSuccess(message: message));
        });
      },
    );
  }
}
