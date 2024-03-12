import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/data/datasources/restaurant_result_remote_data_source.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/filter_item_result_params.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';

import 'restaurant_result_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late SearchResultRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late String baseURL;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    baseURL = dotenv.env['BASE_URL']!;
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = SearchResultRemoteDataSourceImpl(dio: mockDio);
  });

  // Common test data
  final restaurantFilterParams = FilterRestaurantResultsParams(
    searchQuery: "sime",
    selection: RestaurantsFilterState.closest,
    location: Location(latitude: 10.0, longitude: 20.0),
    isFasting: false,
    category: 1,
    rating: 3.0,
    maximumPrice: 4,
    page: 1,
    limit: 10,
  );

  final itemFilterParams = FilterItemResultsParams(
    searchQuery: "vegan",
    selection: ItemsFilterState.mostPopular,
    location: Location(latitude: 12.34, longitude: 56.78),
    isFasting: true,
    category: 2,
    rating: 4.5,
    maximumPrice: 10,
    page: 1,
    limit: 20,
  );

  final mockRestaurantResponse = {
    'data': [
      {
        "id": "12345",
        "name": "The Gourmet Spot",
        "opening_hour": "08:00 AM",
        "closing_hour": "10:00 PM",
        "is_open": true,
        "average_price": 25.99,
        "average_rating": 4.5,
        "number_of_reviews": 230,
        "popularity_index": 85,
        "user_id": "67890",
        "distance": "2.5 km",
        "walking_time": "30 mins",
        "riding_time": "10 mins",
        "currency": "USD",
        "createdAt": "2024-03-19T12:00:00Z",
        "updatedAt": "2024-03-19T12:30:00Z",
        "restaurant_tags": [
          {"id": "tag1", "name": "Italian"},
          {"id": "tag2", "name": "Fine Dining"}
        ],
        "restaurant_images": [
          {
            "id": "image1",
            "is_leading": true,
            "url": "https://example.com/images/restaurant1.jpg",
            "type": "image"
          },
          {
            "id": "image2",
            "is_leading": false,
            "url": "https://example.com/images/restaurant2.jpg",
            "type": "image"
          }
        ],
        "restaurant_videos": [
          {
            "id": "video1",
            "is_leading": true,
            "url": "https://example.com/videos/restaurant_tour.mp4",
            "type": "video"
          }
        ],
        "restaurant_locations": [
          {
            "latitude": 40.7128,
            "longitude": -74.0060,
            "address": "123 Main St, New York, NY"
          }
        ],
        "restaurant_phone_numbers": [
          {"country_code": "+1", "number": "555-1234"}
        ],
        "availability_alert": true,
        "is_order_service_available": true,
        "is_order_service_online": false,
        "menu": {"updatedAt": "2024-03-19T11:45:00Z"},
        "isFavorite": true
      }
    ]
  };

  final mockItemResponse = {
    'data': [
      {
        'id': '1',
        'name': 'Test Item',
        'rating': 4.5,
        'price': 3,
      }
    ]
  };

  group('Restaurant Methods', () {
    test('getMostPopularRestaurants returns list of restaurants', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockRestaurantResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getMostPopularRestaurants(
        filterResultParams: restaurantFilterParams,
        page: 1,
        limit: 10,
      );

      expect(result, isA<List<RestaurantModel>>());
    });

    test('getClosestRestaurants returns list of restaurants', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockRestaurantResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getClosestRestaurants(
        filterResultParams: restaurantFilterParams,
        page: 1,
        limit: 10,
      );

      expect(result, isA<List<RestaurantModel>>());
    });

    test('getHighestRatedRestaurants returns list of restaurants', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockRestaurantResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getHighestRatedRestaurants(
        filterResultParams: restaurantFilterParams,
        page: 1,
        limit: 10,
      );

      expect(result, isA<List<RestaurantModel>>());
    });

    test('getPriceSortedRestaurants returns list of restaurants', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockRestaurantResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getPriceSortedRestaurants(
        filterResultParams: restaurantFilterParams,
        page: 1,
        limit: 10,
      );

      expect(result, isA<List<RestaurantModel>>());
    });
  });

  group('Item Methods', () {
    test('getHighestRatedItems returns list of items', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockItemResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getHighestRatedItems(
        filterResultParams: itemFilterParams,
        page: 1,
        limit: 10,
        latitude: 10.0,
        longitude: 20.0,
      );

      expect(result, isA<List<ItemModel>>());
    });

    test('getClosestItems returns list of items', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockItemResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getClosestItems(
        filterResultParams: itemFilterParams,
        page: 1,
        limit: 10,
        latitude: 10.0,
        longitude: 20.0,
      );

      expect(result, isA<List<ItemModel>>());
    });

    test('getMostPopularItems returns list of items', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockItemResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getMostPopularItems(
        filterResultParams: itemFilterParams,
        page: 1,
        limit: 10,
        latitude: 10.0,
        longitude: 20.0,
      );

      expect(result, isA<List<ItemModel>>());
    });

    test('getPriceSortedItems returns list of items', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: mockItemResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getPriceSortedItems(
        filterResultParams: itemFilterParams,
        page: 1,
        limit: 10,
        latitude: 10.0,
        longitude: 20.0,
      );

      expect(result, isA<List<ItemModel>>());
    });
  });
}
