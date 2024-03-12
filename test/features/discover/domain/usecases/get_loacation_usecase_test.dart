import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/use_case/use_case.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';

import 'get_loacation_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DiscoverRepo>(),
])
void main() {
  late GetLocationUseCase getLocationUseCase;
  late MockDiscoverRepo mockDiscoverRepo;

  setUp(() {
    mockDiscoverRepo = MockDiscoverRepo();
    getLocationUseCase = GetLocationUseCase(discoverRepo: mockDiscoverRepo);
  });

  const testResponse = LocationModel(latitude: 10, longitude: 10);
  test('should get the location', () async {
    // arrange
    when(
      mockDiscoverRepo.getLocation(),
    ).thenAnswer(
      (_) async => const Right(testResponse),
    );

    // act
    final result = await getLocationUseCase(NoParams());
    // assert
    expect(result, const Right(testResponse));
    verify(
      mockDiscoverRepo.getLocation(),
    );
    verifyNoMoreInteractions(mockDiscoverRepo);
  });
}
