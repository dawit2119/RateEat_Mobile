import '../../../domain/use_cases/add_candidate_item_use_case.dart';
import './candidate_item_state.dart';
import './candidate_item_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateItemBloc extends Bloc<CandidateItemEvent, CandidateItemState> {
  final AddCandidateItemUseCase addCandidateItemUseCase;

  CandidateItemBloc({
    required this.addCandidateItemUseCase,
  }) : super(
          AddCandidateItemInitial(),
        ) {
    on<AddCandidateItemEvent>(_onAddCandidateItemEvent);
  }

  void _onAddCandidateItemEvent(
      AddCandidateItemEvent event, Emitter<CandidateItemState> emit) async {
    try {
      emit(
        AddCandidateItemLoading(),
      );
      final response = await addCandidateItemUseCase(
        AddCandidateItemUseCaseParams(
          itemName: event.itemName,
          price: event.price.toString(),
          itemImages: event.itemImages,
          menuId: event.menuId,
          categoryName: event.categoryName,
        ),
      );
      response.fold(
        (error) => emit(
          CandidateItemAddFailed(message: "Unable to add candidate Item"),
        ),
        (candidateItem) => emit(
          CandidateItemAdded(candidateItem: candidateItem),
        ),
      );
    } catch (e) {
      emit(
        CandidateItemAddFailed(message: "Unable to add candidate Item"),
      );
    }
  }
}
