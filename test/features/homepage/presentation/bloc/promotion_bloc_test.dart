import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_state.dart';

import 'promotion_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetPromotionUseCase>(),
])
void main() {
  late PromotionBloc promotionBloc;
  late MockGetPromotionUseCase mockGetPromotionUseCase;

  setUp(() {
    mockGetPromotionUseCase = MockGetPromotionUseCase();
    promotionBloc = PromotionBloc(getPromotionUseCase: mockGetPromotionUseCase);
  });

  final testPromotionParams = NoParams();

  const promotions = [
    Promotion(
      itemId: '1',
      imageUrl: 'imageUrl',
      foodName: 'foodName',
      restaurantName: 'restaurantName',
      discount: 10,
    )
  ];

  group('PromotionBloc', () {
    test('initial state is AllPromotionState', () {
      expect(promotionBloc.state, const AllPromotionState());
    });

    blocTest<PromotionBloc, PromotionState>(
      'should emit [AllPromotionState(status: ItemStatus.loading), AllPromotionState(status: ItemStatus.loaded)] when the call to the GetPromotionEvent is successful',
      build: () {
        when(
          mockGetPromotionUseCase(testPromotionParams),
        ).thenAnswer((_) async => const Right(promotions));
        return promotionBloc;
      },
      act: (bloc) => bloc.add(const GetPromotionEvent(page: 1, limit: 7)),
      expect: () => [
        const AllPromotionState(status: ItemStatus.loading),
        const AllPromotionState(
            status: ItemStatus.loaded, promotions: promotions),
      ],
    );

    blocTest<PromotionBloc, PromotionState>(
      'should emit [AllPromotionState(status: ItemStatus.loading), AllPromotionState(status: ItemStatus.error, errorMessage: "Error")] when the call to the GetPromotionEvent is unsuccessful',
      build: () {
        when(
          mockGetPromotionUseCase(testPromotionParams),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return promotionBloc;
      },
      act: (bloc) => bloc.add(const GetPromotionEvent(page: 1, limit: 7)),
      expect: () => [
        const AllPromotionState(status: ItemStatus.loading),
        const AllPromotionState(
            status: ItemStatus.error, errorMessage: "Error"),
      ],
    );
  });
}
