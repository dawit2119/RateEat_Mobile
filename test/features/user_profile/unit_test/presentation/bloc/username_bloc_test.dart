import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/check_username_availability_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/username_availability/username_availability_bloc.dart';

import 'username_bloc_test.mocks.dart';

class MockCheckUserNameAvailabilityUseCase extends Mock
    implements CheckUserNameAvailabilityUseCase {}

@GenerateMocks([MockCheckUserNameAvailabilityUseCase])
void main() {
  late MockCheckUserNameAvailabilityUseCase
      mockCheckUserNameAvailabilityUseCase;
  late UsernameAvailabilityBloc usernameAvailabilityBloc;

  setUp(() {
    mockCheckUserNameAvailabilityUseCase =
        MockMockCheckUserNameAvailabilityUseCase();
    usernameAvailabilityBloc = UsernameAvailabilityBloc(
        checkUserNameAvailabilityUseCase: mockCheckUserNameAvailabilityUseCase);
  });

  group('UsernameAvailabilityBloc', () {
    test(
        'should emit [UsernameAvailabilityLoading, UsernameAvailabilitySuccess] when checking username availability is successful',
        () async {
      const userName = 'test_username';
      const expectedState = UsernameAvailabilitySuccess(status: 'is available');
      when(mockCheckUserNameAvailabilityUseCase(
              const QueryParams(userName: userName)))
          .thenAnswer((_) async => const Right(true));

      usernameAvailabilityBloc
          .add(CheckUserNameAvailability(userName: userName));

      await expectLater(
        usernameAvailabilityBloc.stream,
        emitsInOrder([
          const UsernameAvailabilityLoading(
              status: 'Checking username availability...'),
          expectedState,
        ]),
      );
      verify(mockCheckUserNameAvailabilityUseCase(
              const QueryParams(userName: userName)))
          .called(1);
    });

    test(
        'should emit [UsernameAvailabilityLoading, UsernameAvailabilityFailed] when checking username availability fails',
        () async {
      const userName = 'test_username';

      final error = ServerFailure();
      final expectedState = UsernameAvailabilityFailed(
          status: error.errorMessage); // Expected state
      when(mockCheckUserNameAvailabilityUseCase(
              const QueryParams(userName: userName)))
          .thenAnswer((_) async => Left(error));

      usernameAvailabilityBloc
          .add(CheckUserNameAvailability(userName: userName));

      await expectLater(
        usernameAvailabilityBloc.stream,
        emitsInOrder([
          const UsernameAvailabilityLoading(
              status: 'Checking username availability...'),
          expectedState,
        ]),
      );
      verify(mockCheckUserNameAvailabilityUseCase(
              const QueryParams(userName: userName)))
          .called(1);
    });

    test('should emit [UsernameAvailabilityInitial] when reset to initial',
        () async {
      usernameAvailabilityBloc.add(ResetUserNameToInitial());

      await expectLater(
        usernameAvailabilityBloc.stream,
        emits(const UsernameAvailabilityInitial(status: '')),
      );
    });
  });
}
