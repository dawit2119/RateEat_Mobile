import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/error.dart';
import 'package:rateeat_mobile/src/features/settings/domain/repostiory/feedbackrepo.dart';
import 'package:rateeat_mobile/src/features/settings/domain/usecase/feedbackusecase.dart';

import 'feedback_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FeedbackRepository>(),
])
void main() {
  late MockFeedbackRepository mockFeedbackRepository;
  late FeedbackUseCase feedbackUseCase;
  setUp(() {
    mockFeedbackRepository = MockFeedbackRepository();
    feedbackUseCase = FeedbackUseCase(
      feedbackRepository: mockFeedbackRepository,
    );
  });

  const comment = "Comment";
  test("Feedback use case should save the feedback and return the comment",
      () async {
    //Arrange
    when(mockFeedbackRepository.giveFeedback(comment)).thenAnswer(
      (realInvocation) async => const Right(comment),
    );
    //Act
    var result = await feedbackUseCase.giveFeedback(comment);
    //Assert
    expect(
      result,
      const Right(comment),
    );
  });

  test('FeedBackUsecase should return Server Failure', () async {
    // Arrange
    when(mockFeedbackRepository.giveFeedback(comment)).thenAnswer(
      (realInvocation) async => Left(ServerFailure()),
    );
    // Act
    var result = await feedbackUseCase.giveFeedback(comment);

    // Assert
    expect(
      result,
      Left(ServerFailure()),
    );
  });
}
