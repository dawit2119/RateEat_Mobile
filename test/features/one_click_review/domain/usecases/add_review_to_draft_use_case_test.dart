import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/repositories/nearby_places_repository.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/add_review_to_draft_usecase.dart';

import 'add_review_to_draft_use_case_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NearByPlacesRepository>(),
])
void main() {
  late MockNearByPlacesRepository mockNearByPlacesRepository;
  late AddReviewToDraftUseCase addReviewToDraftUseCase;
  final draftReviewRequestModel = DraftReviewRequestModel(
    itemId: "3u384af",
    restaurantId: "eriuiurie",
    images: [],
    videos: [],
  );
  setUp(() {
    mockNearByPlacesRepository = MockNearByPlacesRepository();
    addReviewToDraftUseCase = AddReviewToDraftUseCase(
      repository: mockNearByPlacesRepository,
    );
  });

  test("Should add draft review", () async {
    //Arrange
    when(
      mockNearByPlacesRepository.addReviewToDraft(
        draftReviewRequestModel: draftReviewRequestModel,
      ),
    ).thenAnswer(
      (_) async => const Right(
        "Draft review added",
      ),
    );
    //Act
    final result = await addReviewToDraftUseCase(
      DraftReviewUseCaseParams(
        draftReviewRequestModel: draftReviewRequestModel,
      ),
    );
    expect(
      result,
      const Right("Draft review added"),
    );
    //Assert
    verify(
      mockNearByPlacesRepository.addReviewToDraft(
        draftReviewRequestModel: draftReviewRequestModel,
      ),
    );
    verifyNoMoreInteractions(
      mockNearByPlacesRepository,
    );
  });
}
