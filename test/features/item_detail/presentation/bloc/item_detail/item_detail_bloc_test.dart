import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_state.dart';

import 'item_detail_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetItemUseCase>(),
  MockSpec<LocalItemDetailDataSource>(),
])
void main() {
  late ItemDetailBloc bloc;
  late MockGetItemUseCase mockGetItemUseCase;
  late MockLocalItemDetailDataSource mockLocalItemDetailDataSource;

  setUp(() async {
    mockGetItemUseCase = MockGetItemUseCase();
    mockLocalItemDetailDataSource = MockLocalItemDetailDataSource();
    bloc = ItemDetailBloc(itemUseCase: mockGetItemUseCase);
    await dpLocator.reset();
    dpLocator.registerLazySingleton<LocalItemDetailDataSource>(
        () => mockLocalItemDetailDataSource);
  });

  tearDown(() {
    bloc.close();
  });

  group('ItemDetailBloc', () {
    const String itemId = 'item1';

    test('initial state is ItemDetailInitial', () {
      expect(bloc.state, ItemDetailInitial());
    });

    test(
        'emits [ItemDetailLoading, ItemDetailSuccess] when GetItemDetailEvent is successful',
        () async {
      final item =
          Item(itemId: itemId, itemName: 'Test Item', numberOfReviews: 0);
      when(mockGetItemUseCase(itemId)).thenAnswer((_) async => Right(item));

      bloc.add(GetItemDetailEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          ItemDetailLoading(),
          ItemDetailSuccess(item: item, isLocal: false),
        ]),
      );
    });

    test(
        'emits [ItemDetailLoading, ItemDetailError] when GetItemDetailEvent fails and local item is null',
        () async {
      when(mockGetItemUseCase(itemId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Error')));
      when(mockLocalItemDetailDataSource.getItemDetail(itemId))
          .thenThrow(Exception('Local item not found'));

      bloc.add(GetItemDetailEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          ItemDetailLoading(),
          ItemDetailError(error: "Unable to get Item Detail"),
        ]),
      );
    });

    test(
        'emits [ItemDetailLoading, ItemDetailSuccess] when GetItemDetailEvent fails but local item is available',
        () async {
      final localItem =
          Item(itemId: itemId, itemName: 'Local Test Item', numberOfReviews: 0);
      when(mockGetItemUseCase(itemId)).thenAnswer(
          (_) async => Left(ServerFailure(errorMessage: "Server failure")));
      when(mockLocalItemDetailDataSource.getItemDetail(itemId))
          .thenAnswer((_) async => localItem);

      bloc.add(GetItemDetailEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          ItemDetailLoading(),
          ItemDetailSuccess(item: localItem, isLocal: true),
        ]),
      );
    });

    test('emits [ItemDetailLoading, ItemDetailError] on unexpected exceptions',
        () async {
      when(mockGetItemUseCase(itemId)).thenThrow(Exception('Unexpected error'));

      bloc.add(GetItemDetailEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          ItemDetailLoading(),
          isA<ItemDetailError>(),
        ]),
      );
    });
  });
}
