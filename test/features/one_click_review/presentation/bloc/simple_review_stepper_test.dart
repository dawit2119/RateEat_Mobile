import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/simple_review_stepper_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';

void main() {
  late SimpleReviewStepperBloc simpleReviewStepperBloc;

  setUp(() {
    simpleReviewStepperBloc = SimpleReviewStepperBloc();
  });

  group("Simple stepper bloc unit test", () {
    test("Initial state should be AddReviewToDraftInitial", () {
      expect(
        simpleReviewStepperBloc.state,
        const SimpleReviewStepperState(
          simpleAddReviewStepperProps: SimpleAddReviewStepperModel(),
        ),
      );
    });
    blocTest<SimpleReviewStepperBloc, SimpleReviewStepperState>(
      "Should emit [ AddReviewToDraftLoading -> AddReviewToDraftSuccess]",
      build: () {
        return simpleReviewStepperBloc;
      },
      act: (bloc) => bloc.add(const SimpleReviewStepperUpdate()),
      expect: () => <SimpleReviewStepperState>[
        const SimpleReviewStepperState(
          simpleAddReviewStepperProps: SimpleAddReviewStepperModel(),
        )
      ],
    );
  });
}
