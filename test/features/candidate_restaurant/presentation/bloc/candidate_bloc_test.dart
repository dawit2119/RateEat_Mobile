import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/usecase/candidate_usecase.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_bloc.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidatae_event.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_state.dart';

import 'candidate_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CandidateUseCase>(),
])
void main() {
  late CandidateBloc candidateBloc;
  late MockCandidateUseCase mockCandidateUseCase;

  setUp(() {
    mockCandidateUseCase = MockCandidateUseCase();
    candidateBloc = CandidateBloc(candidateUseCase: mockCandidateUseCase);
  });

  group('CandidateBloc', () {
    final mockCandidRest = CandidRest(name: '', menuImages: []);

    test('emits loading and success states when submission is successful',
        () async {
      const mockResponse = 'Success message';
      when(mockCandidateUseCase.createCandidateRestaurant(
              candidRest: mockCandidRest))
          .thenAnswer((_) async => const Right(mockResponse));

      candidateBloc.add(SubmitCandidate(candidRest: mockCandidRest));

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          CandidateLoading(),
          CandidateSuccess(message: mockResponse),
        ]),
      );
    });

    test('emits loading and failure states when submission fails', () async {
      const failureMessage = 'Test Failure Message';
      final failure = ServerFailure();
      when(mockCandidateUseCase.createCandidateRestaurant(
              candidRest: mockCandidRest))
          .thenAnswer((_) async => Left(failure));

      candidateBloc.add(SubmitCandidate(candidRest: mockCandidRest));

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          CandidateLoading(),
          CandidateFailure(error: failureMessage),
        ]),
      );
    });

    test('emits loading and failure states if use case throws error', () async {
      const failureMessage = 'Test Failure Message';
      when(mockCandidateUseCase.createCandidateRestaurant(
              candidRest: mockCandidRest))
          .thenThrow(ServerException(errorMessage: 'Test Failure Message'));

      candidateBloc.add(SubmitCandidate(candidRest: mockCandidRest));

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          CandidateLoading(),
          CandidateFailure(error: failureMessage),
        ]),
      );
    });

    test("event get props test", () {
      final event = SubmitCandidate(candidRest: mockCandidRest);
      expect(event.props, []);
    });
  });
}
