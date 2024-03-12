import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import '../highest_rated/popular_state.dart';

part 'promotion_event.dart';
part 'promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final GetPromotionUseCase getPromotionUseCase;
  PromotionBloc({required this.getPromotionUseCase})
      : super(const AllPromotionState()) {
    on<GetPromotionEvent>(_onGetPromotion);
  }

  void _onGetPromotion(
      GetPromotionEvent event, Emitter<PromotionState> emit) async {
    emit(const AllPromotionState(status: ItemStatus.loading));
    // Get Promotions;
    final failureOrPromotion = await getPromotionUseCase(NoParams());
    return emit(_eitherPromotionOrError(failureOrPromotion));
  }

  PromotionState _eitherPromotionOrError(
      Either<Failure, List<Promotion>> failureOrPromotion) {
    return failureOrPromotion.fold(
      (error) => const AllPromotionState(
          status: ItemStatus.error, errorMessage: "Error"),
      (promotions) =>
          AllPromotionState(status: ItemStatus.loaded, promotions: promotions),
    );
  }
}
