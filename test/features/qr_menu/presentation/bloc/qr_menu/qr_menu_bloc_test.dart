import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import 'qr_menu_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetQRMenuUsecase>(),
])
void main() {
  late QRMenuBloc qrMenuBloc;
  late MockGetQRMenuUsecase mockGetQRMenuUsecase;

  setUp(() {
    mockGetQRMenuUsecase = MockGetQRMenuUsecase();
    qrMenuBloc = QRMenuBloc(getQrMenuUsecase: mockGetQRMenuUsecase);
  });

  test('initial state should be QRMenuInitial', () {
    expect(qrMenuBloc.state, isA<QRMenuInitial>());
  });

  group('GetQRMenu', () {
    const restaurantId = '1';
    const page = 1;

    test('should emit QRMenuLoading when there is no previous menu', () {
      final menu = QRMenuModel(
        restaurantId: '1',
        restaurantName: "restaurant name",
        restaurantImageUrl: '',
        itemBackgroundColor: '',
        items: <QRCategory, List<QRItem>>{},
        backgroundColor: '',
        categories: <QRCategory>[],
        totalCategories: 0,
        restaurant: null,
      );
      when(mockGetQRMenuUsecase(any)).thenAnswer((_) async => Right(menu));
      qrMenuBloc.add(GetQRMenu(
          restaurantId: restaurantId,
          page: page,
          sortType: 'Desc',
          isFasting: false,
          query: '',
          minPrice: 0,
          maxPrice: 0,
          minRating: 0,
          sortBy: 'popularity'));
      expectLater(
        qrMenuBloc.stream,
        emitsInOrder([isA<QRMenuLoading>()]),
      );
    });

    test('should emit QRMenuLoaded when fetch is successful', () async {
      final menu = QRMenuModel(
        restaurantId: 'restaurant id',
        restaurantName: "restaurant name",
        restaurantImageUrl: '',
        itemBackgroundColor: '',
        items: <QRCategory, List<QRItem>>{},
        backgroundColor: '',
        categories: <QRCategory>[],
        totalCategories: 0,
        restaurant: null,
      );
      when(mockGetQRMenuUsecase(any)).thenAnswer((_) async => Right(menu));

      qrMenuBloc.add(GetQRMenu(
          restaurantId: restaurantId,
          page: page,
          sortType: 'Desc',
          isFasting: false,
          query: '',
          minPrice: 0,
          maxPrice: 0,
          minRating: 0,
          sortBy: 'popularity'));
      await expectLater(
        qrMenuBloc.stream,
        emitsInOrder([isA<QRMenuLoading>(), isA<QRMenuLoaded>()]),
      );
    });

    test('should emit QRMenuFailed when fetch fails', () async {
      when(mockGetQRMenuUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      qrMenuBloc.add(GetQRMenu(
          restaurantId: restaurantId,
          page: page,
          sortType: 'Desc',
          isFasting: false,
          query: '',
          minPrice: 0,
          maxPrice: 0,
          minRating: 0,
          sortBy: 'popularity'));
      await expectLater(
        qrMenuBloc.stream,
        emitsInOrder([isA<QRMenuLoading>(), isA<QRMenuFailed>()]),
      );
    });

    test('should handle pagination correctly', () async {
      final menu1 = QRMenuModel(
        restaurantId: '1',
        restaurantName: "restaurant name",
        restaurantImageUrl: '',
        itemBackgroundColor: '',
        items: <QRCategory, List<QRItem>>{},
        backgroundColor: '',
        categories: <QRCategory>[],
        totalCategories: 0,
        restaurant: null,
      );
      final menu2 = QRMenuModel(
        restaurantId: '1',
        restaurantName: "restaurant name",
        restaurantImageUrl: '',
        itemBackgroundColor: '',
        items: <QRCategory, List<QRItem>>{},
        backgroundColor: '',
        categories: <QRCategory>[],
        totalCategories: 0,
        restaurant: null,
      );
      when(mockGetQRMenuUsecase(any)).thenAnswer((_) async => Right(menu1));

      qrMenuBloc.add(GetQRMenu(
          restaurantId: restaurantId,
          page: page,
          sortType: 'Desc',
          isFasting: false,
          query: '',
          minPrice: 0,
          maxPrice: 0,
          minRating: 0,
          sortBy: 'popularity'));
      await expectLater(
        qrMenuBloc.stream,
        emitsInOrder([isA<QRMenuLoading>(), isA<QRMenuLoaded>()]),
      );

      when(mockGetQRMenuUsecase(any)).thenAnswer((_) async => Right(menu2));
      qrMenuBloc.add(GetQRMenu(
          restaurantId: restaurantId,
          page: page,
          sortType: 'Desc',
          isFasting: false,
          query: '',
          minPrice: 0,
          maxPrice: 0,
          minRating: 0,
          sortBy: 'popularity'));
      await expectLater(
        qrMenuBloc.stream,
        emitsInOrder([
          isA<QRMenuLoading>(),
          isA<QRMenuLoaded>(),
        ]),
      );
      when(mockGetQRMenuUsecase(any)).thenAnswer((_) async => Right(menu2));
      qrMenuBloc.add(GetQRMenu(
          restaurantId: restaurantId,
          page: 2,
          sortType: 'Desc',
          isFasting: false,
          query: '',
          minPrice: 0,
          maxPrice: 0,
          minRating: 0,
          sortBy: 'popularity'));
      await expectLater(
        qrMenuBloc.stream,
        emitsInOrder([
          isA<QRMenuNextLoading>(),
          isA<QRMenuLoaded>(),
        ]),
      );
    });
  });
}
