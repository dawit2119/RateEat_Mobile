import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/data_sources/candid_rest_data_sources.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';

import 'package:rateeat_mobile/src/features/candidate_restaurant/data/repository/candidate_repo_impl.dart';

import 'candidate_repo_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CandidateDataSource>(),
])
void main() {
  late CandidateRepoImpl candidateRepo;
  late MockCandidateDataSource mockCandidDataSource;

  setUp(() {
    mockCandidDataSource = MockCandidateDataSource();
    candidateRepo =
        CandidateRepoImpl(candidateDataSource: mockCandidDataSource);
  });

  group('CandidateRepoImpl', () {
    final mockCandidRest = CandidRest(
      name: 'Test Restaurant',
      menuImages: [],
    );
    test(
        'calls createCandidate method of data source with the correct parameters',
        () async {
      // Arrange

      const mockResponse = 'Success';
      when(mockCandidDataSource.createCandidate(mockCandidRest))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await candidateRepo.createCandidateRestaurant(
          candidRest: mockCandidRest);

      // Assert
      expect(result, const Right(mockResponse));
      verify(mockCandidDataSource.createCandidate(mockCandidRest)).called(1);
      verifyNoMoreInteractions(mockCandidDataSource);
    });

    test('returns a failure when data source throws an exception', () async {
      // Arrange

      final mockException = ServerException();
      when(mockCandidDataSource.createCandidate(mockCandidRest))
          .thenThrow(mockException);

      // Act
      final result = await candidateRepo.createCandidateRestaurant(
          candidRest: mockCandidRest);

      // Assert
      expect(
          result, Left(ServerFailure(errorMessage: mockException.toString())));
      verify(mockCandidDataSource.createCandidate(mockCandidRest)).called(1);
      verifyNoMoreInteractions(mockCandidDataSource);
    });
  });
}
