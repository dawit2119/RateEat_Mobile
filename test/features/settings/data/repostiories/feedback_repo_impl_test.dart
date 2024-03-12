import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/settings/data/datasources/remote_feedback_datasource.dart';
import 'package:rateeat_mobile/src/features/settings/data/repostiories/feedbackrepoimpl.dart';

import 'feedback_repo_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FeedbackDataSource>(),
])
void main() {
  late MockFeedbackDataSource mockFeedbackDataSource;
  late FeedbackRepoImpl feedbackRepoImpl;
  setUp(() {
    mockFeedbackDataSource = MockFeedbackDataSource();
    feedbackRepoImpl = FeedbackRepoImpl(
      feedbackDataSource: mockFeedbackDataSource,
    );
  });
  const comment = "Comment";
  test("Feedback repository should save data and return the comment", () async {
    //Arrange
    when(mockFeedbackDataSource.giveFeedback(comment)).thenAnswer(
      (_) async => comment,
    );
    //Act
    final result = await feedbackRepoImpl.giveFeedback(
      comment,
    );
    //Assert
    expect(
      result,
      const Right(
        comment,
      ),
    );
  });

  test('Feedback repository should return Server Failure', () async {
    // Arrange
    when(mockFeedbackDataSource.giveFeedback(comment)).thenThrow(
      ServerException(),
    );
    // Act
    final result = await feedbackRepoImpl.giveFeedback(
      comment,
    );

    // Assert
    expect(
      result,
      Left(
        ServerFailure(),
      ),
    );
  });
}
