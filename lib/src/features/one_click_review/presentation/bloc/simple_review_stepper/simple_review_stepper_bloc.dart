import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/simple_review_stepper_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';

part 'simple_review_stepper_event.dart';
part 'simple_review_stepper_state.dart';

class SimpleReviewStepperBloc
    extends Bloc<SimpleReviewStepperEvent, SimpleReviewStepperState> {
  SimpleReviewStepperBloc()
      : super(
          const SimpleReviewStepperState(
            simpleAddReviewStepperProps: SimpleAddReviewStepperModel(),
          ),
        ) {
    on<SimpleReviewStepperUpdate>(_onContentChanged);
  }
  _onContentChanged(SimpleReviewStepperUpdate event,
      Emitter<SimpleReviewStepperState> emit) async {
    var newState = state.simpleAddReviewStepperProps.copyWith(
      item: event.item,
      images: event.images ?? state.simpleAddReviewStepperProps.images,
      videos: event.videos ?? state.simpleAddReviewStepperProps.videos,
      restaurant:
          event.restaurant ?? state.simpleAddReviewStepperProps.restaurant,
    );
    emit(SimpleReviewStepperState(simpleAddReviewStepperProps: newState));
  }
}
