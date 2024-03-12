import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/item_review_card_flag/item_review_card_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/item_review_card_flag/item_review_card_state.dart';

class ItemReviewsCardBloc
    extends Bloc<ItemReviewsCardEvent, ItemReviewsCardState> {
  ItemReviewsCardBloc() : super(ItemReviewsCardInitial(id: "")) {
    on<ItemReviewsCardFlaggedEvent>((event, emit) {
      emit(ItemReviewsCardFlagged(id: event.id));
    });
    on<ItemReviewsCardNormalEvent>((event, emit) {
      emit(ItemReviewsCardInitial(id: event.id));
    });
  }
}
