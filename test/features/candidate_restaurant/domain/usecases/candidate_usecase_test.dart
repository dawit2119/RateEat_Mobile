import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/repository/candidate_repo.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/usecase/candidate_usecase.dart';

import 'candidate_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CandidateRepository>(),
])
void main() {
  late CandidateUseCase candidateUseCase;
  late MockCandidateRepository mockCandidateRepository;

  setUp(() {
    mockCandidateRepository = MockCandidateRepository();
    candidateUseCase =
        CandidateUseCase(candidateRepository: mockCandidateRepository);
  });

  group('CandidateUseCase', () {
    final mockCandidRest = CandidRest(
      name: 'Test Restaurant',
      menuImages: [],
    );
    test('calls createCandidateRestaurant method with the correct parameters',
        () async {
      // Arrange

      const mockResponse = 'Success message';
      when(mockCandidateRepository.createCandidateRestaurant(
              candidRest: mockCandidRest))
          .thenAnswer((_) async => const Right(mockResponse));

      // Act
      final result = await candidateUseCase.createCandidateRestaurant(
          candidRest: mockCandidRest);

      // Assert
      expect(result, const Right(mockResponse));
      verify(mockCandidateRepository.createCandidateRestaurant(
              candidRest: mockCandidRest))
          .called(1);
      verifyNoMoreInteractions(mockCandidateRepository);
    });

    test('calls createCandidateRestaurant method with the correct parameters',
        () async {
      // Arrange

      final failure = ServerFailure(errorMessage: 'Test failure message');
      when(mockCandidateRepository.createCandidateRestaurant(
              candidRest: mockCandidRest))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await candidateUseCase.createCandidateRestaurant(
          candidRest: mockCandidRest);

      // Assert
      expect(result, Left(failure));
      verify(mockCandidateRepository.createCandidateRestaurant(
              candidRest: mockCandidRest))
          .called(1);
      verifyNoMoreInteractions(mockCandidateRepository);
    });
  });
}
