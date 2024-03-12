import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/domain.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_state.dart';

class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> {
  final GetItemUseCase itemUseCase;
  ItemDetailBloc({required this.itemUseCase}) : super(ItemDetailInitial()) {
    on<GetItemDetailEvent>(
      (event, emit) async {
        emit(ItemDetailLoading());
        try {
          var result = await itemUseCase(event.itemId);
          Item? localItem;
          try {
            if (result.isLeft()) {
              localItem = await dpLocator<LocalItemDetailDataSource>()
                  .getItemDetail(event.itemId);
            } else {
              localItem = null;
            }
          } catch (e) {
            localItem = null;
          }

          result.fold(
            (error) {
              if (localItem != null) {
                emit(ItemDetailSuccess(item: localItem, isLocal: true));
              } else {
                emit(ItemDetailError(error: "Unable to get Item Detail"));
              }
            },
            (item) {
              try {
                dpLocator<LocalItemDetailDataSource>().saveItemDetail(item);
              } catch (e) {
                //failed to cache item detail
              }
              emit(
                ItemDetailSuccess(item: item, isLocal: false),
              );
            },
          );
        } catch (e) {
          emit(ItemDetailError(error: e.toString()));
        }
      },
    );
  }
}
