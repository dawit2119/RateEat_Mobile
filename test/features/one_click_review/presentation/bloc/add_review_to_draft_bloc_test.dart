import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/add_review_to_draft_usecase.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/add_review_to_draft/add_review_to_draft_bloc.dart';

import 'add_review_to_draft_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AddReviewToDraftUseCase>()])
void main() {
  late MockAddReviewToDraftUseCase mockAddReviewToDraftUseCase;
  late AddReviewToDraftBloc addReviewToDraftBloc;

  setUp(() {
    mockAddReviewToDraftUseCase = MockAddReviewToDraftUseCase();
    addReviewToDraftBloc = AddReviewToDraftBloc(
      addReviewToDraftUseCase: mockAddReviewToDraftUseCase,
    );
  });

  group("Add draft review bloc unit tes", () {
    test("Initial state should be AddReviewToDraftInitial", () {
      expect(
        addReviewToDraftBloc.state,
        AddReviewToDraftInitial(),
      );
    });
    final draftReviewRequestModel = DraftReviewRequestModel(
      itemId: "3u384af",
      restaurantId: "eriuiurie",
      images: [],
      videos: [],
    );
    blocTest<AddReviewToDraftBloc, AddReviewToDraftState>(
        "Should emit [ AddReviewToDraftLoading -> AddReviewToDraftSuccess]",
        build: () {
          when(mockAddReviewToDraftUseCase(any
              // DraftReviewUseCaseParams(
              //   draftReviewRequestModel: draftReviewRequestModel,
              // ),
              )).thenAnswer(
            (_) async => const Right("Draft review added"),
          );
          return addReviewToDraftBloc;
        },
        act: (bloc) => bloc.add(
              AddDraftRequestEvent(
                draftReviewRequestModel: draftReviewRequestModel,
              ),
            ),
        expect: () => <AddReviewToDraftState>[
              AddReviewToDraftLoading(),
              AddReviewToDraftSuccess(message: "Draft review added"),
            ]);
  });
}
