import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_event.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_state.dart';

class TagBloc extends Bloc<TagEvent, SelectedTagState> {
  TagBloc() : super(const SelectedTagState([])) {
    on<SelectTag>(_selectFoodCategory);
    on<UnselectTag>(_unselectedFoodCategories);
  }

  Future<void> _selectFoodCategory(SelectTag event, Emitter emit) async {
    var newTag = event.tag;
    var newTags = [...state.selectedTags, newTag];

    emit(SelectedTagState(newTags));
  }

  Future<void> _unselectedFoodCategories(
      UnselectTag event, Emitter emit) async {
    var newTags = state.selectedTags.where((tag) => tag != event.tag).toList();
    emit(SelectedTagState(newTags));
  }
}
