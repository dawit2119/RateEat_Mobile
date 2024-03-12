import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_category/data/dataprovider/local_item_category_data_provider.dart';

import 'item_category_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GeTagSuggestionUseCase>(),
  MockSpec<SearchFoodCategoryUseCase>(),
  MockSpec<LocalItemCategoryDataProvider>(),
])
void main() {
  late SearchFoodCategoryBloc searchFoodCategoryBloc;
  late MockGeTagSuggestionUseCase mockGeTagSuggestionUseCase;
  late MockSearchFoodCategoryUseCase mockSearchFoodCategoryUseCase;
  late MockLocalItemCategoryDataProvider mockLocalItemCategoryDataProvider;

  setUp(() async {
    mockGeTagSuggestionUseCase = MockGeTagSuggestionUseCase();
    mockSearchFoodCategoryUseCase = MockSearchFoodCategoryUseCase();
    mockLocalItemCategoryDataProvider = MockLocalItemCategoryDataProvider();
    final dpLocator = GetIt.instance;
    await dpLocator.reset();
    dpLocator.registerLazySingleton<LocalItemCategoryDataProvider>(
        () => mockLocalItemCategoryDataProvider);

    searchFoodCategoryBloc = SearchFoodCategoryBloc(
      geTagSuggestionUseCase: mockGeTagSuggestionUseCase,
      searchFoodCategoryUseCase: mockSearchFoodCategoryUseCase,
    );
  });

  tearDown(() {
    searchFoodCategoryBloc.close();
  });

  group('SearchFoodCategoryBloc', () {
    blocTest<SearchFoodCategoryBloc, SearchFoodCategoryState>(
      'emits [SearchLoading, SearchSuccess] when GetCategorySuggestion is added and returns categories',
      build: () {
        when(mockGeTagSuggestionUseCase(NoParams())).thenAnswer(
            (_) async => Right([ItemCategoryModel(id: '1', name: 'Fruits')]));
        when(mockLocalItemCategoryDataProvider.getItemCategories())
            .thenAnswer((_) async => []);
        return searchFoodCategoryBloc;
      },
      act: (bloc) => bloc.add(GetCategorySuggestion()),
      expect: () => [
        SearchLoading(),
        SearchSuccess([ItemCategoryModel(id: '1', name: 'Fruits')]),
      ],
    );

    blocTest<SearchFoodCategoryBloc, SearchFoodCategoryState>(
      'emits [SearchLoading, SearchSuccess] when GetCategorySuggestion is added and local categories are returned',
      build: () {
        when(mockGeTagSuggestionUseCase(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        when(mockLocalItemCategoryDataProvider.getItemCategories()).thenAnswer(
            (_) async => [ItemCategory(id: '2', name: 'Vegetables')]);
        return searchFoodCategoryBloc;
      },
      act: (bloc) => bloc.add(GetCategorySuggestion()),
      expect: () => [
        SearchLoading(),
        SearchSuccess([ItemCategoryModel(id: '2', name: 'Vegetables')]),
      ],
    );

    blocTest<SearchFoodCategoryBloc, SearchFoodCategoryState>(
      'emits [SearchLoading, SearchError] when GetCategorySuggestion fails',
      build: () {
        when(mockGeTagSuggestionUseCase(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        when(mockLocalItemCategoryDataProvider.getItemCategories())
            .thenAnswer((_) async => []);
        return searchFoodCategoryBloc;
      },
      act: (bloc) => bloc.add(GetCategorySuggestion()),
      expect: () => [
        SearchLoading(),
        SearchError(message: 'Server failure'),
      ],
    );

    blocTest<SearchFoodCategoryBloc, SearchFoodCategoryState>(
      'emits [SearchLoading, SearchSuccess] when SearchSubmitted is added',
      build: () {
        when(mockSearchFoodCategoryUseCase(SearchFoodCategoryUseCaseParams(
                query: 'Fruits', pageNumber: 1)))
            .thenAnswer((_) async =>
                Right([ItemCategoryModel(id: '1', name: 'Fruits')]));
        return searchFoodCategoryBloc;
      },
      act: (bloc) => bloc.add(SearchSubmitted(query: 'Fruits', pageNumber: 1)),
      expect: () => [
        SearchLoading(),
        SearchSuccess([ItemCategoryModel(id: '1', name: 'Fruits')]),
      ],
    );

    blocTest<SearchFoodCategoryBloc, SearchFoodCategoryState>(
      'emits [SearchLoading, SearchError] when SearchSubmitted fails',
      build: () {
        when(mockSearchFoodCategoryUseCase(SearchFoodCategoryUseCaseParams(
                query: 'Fruits', pageNumber: 1)))
            .thenAnswer((_) async => Left(ServerFailure()));
        return searchFoodCategoryBloc;
      },
      act: (bloc) => bloc.add(SearchSubmitted(query: 'Fruits', pageNumber: 1)),
      expect: () => [
        SearchLoading(),
        SearchError(message: 'Server failure'),
      ],
    );
  });
}
