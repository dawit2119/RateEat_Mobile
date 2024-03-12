import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/domain.dart';

import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/recommended_items/recommended_items_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/recommended_items/recommended_items_state.dart';

class DetailRecommendationBloc
    extends Bloc<RecommendedItemsEvent, DetailRecommendedState> {
  final GetItemRecommendationsUseCase getItemRecommendationsUseCase;
  DetailRecommendationBloc({required this.getItemRecommendationsUseCase})
      : super(DetailRecommendedInitial()) {
    on<GetRecommendedItemsEvent>(
      (event, emit) async {
        emit(DetailRecommendedLoading());
        try {
          final result = await getItemRecommendationsUseCase(event.itemId);
          final List<Item>? localRecommendations;
          if (result.isLeft()) {
            localRecommendations = await dpLocator<LocalItemDetailDataSource>()
                .getRecommendedItems(
              event.itemId,
            );
          } else {
            localRecommendations = null;
            try {
              await dpLocator<LocalItemDetailDataSource>().saveRecommendedItems(
                event.itemId,
                result.getOrElse(() {
                  throw Exception("failed to save recommendations");
                }),
              );
            } catch (e) {
              //failed to save recommended items
              debugPrint("failed to save recommended items failure $e");
            }
          }
          result.fold(
            (l) {
              if (localRecommendations != null) {
                emit(DetailRecommendedSuccess(
                    recommendations: localRecommendations, isLocal: true));
              } else {
                emit(
                  DetailRecommendedError(
                      error: "Unable to get item recommendations"),
                );
              }
            },
            (items) => emit(DetailRecommendedSuccess(
                recommendations: items, isLocal: false)),
          );
        } catch (e) {
          emit(DetailRecommendedError(error: e.toString()));
        }
      },
    );
  }
}
