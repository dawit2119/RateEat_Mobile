import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

import 'order_history_data_sources_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AuthenticationLocalSource>()])
void main() {
  late MockDio mockDio;
  late OrderHistoryDataSourceImpl dataSource;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  final token = LocalUserModel(token: 'token');

  setUp(() async {
    await dotenv.load(fileName: ".env");
    mockDio = MockDio();
    dataSource = OrderHistoryDataSourceImpl(dio: mockDio);
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);
  });

  group('test getOrders', () {
    final String userId = '123';
    final String status = 'pending';
    final int page = 1;
    final int limit = 10;

    final responsePayLoad = [
      {
        "id": "12345",
        "user_id": "user_67890",
        "restaurant_id": "restaurant_54321",
        "order_status": "completed",
        "order_type": "dine-in",
        "total_price": 2500,
        "total_number_of_items": 5,
        "estimated_waiting_time": 30,
        "order_message": "Please deliver to the side door.",
        "createdAt": "2025-02-18T12:34:56.789Z",
        "updatedAt": "2025-02-18T13:45:67.890Z",
        "order_items": [
          {"id": "item_1", "name": "Burger", "quantity": 2, "price": 500},
          {"id": "item_2", "name": "Fries", "quantity": 1, "price": 200},
          {"id": "item_3", "name": "Soda", "quantity": 2, "price": 150}
        ]
      }
    ];

    test('getOrders should return items on success', () async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);

      when(mockDio.get(
              '$apiKey/orders/history?status=${status.toLowerCase()}&limit=$limit&page=$page',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: {
                'data': responsePayLoad,
              }, statusCode: 200, requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getOrders(
          userId: userId, status: status, page: page, limit: limit);

      expect(result,
          responsePayLoad.map((e) => OrderHistoryModel.fromMap(e)).toList());
    });

    test('should return error on failure', () async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);

      when(mockDio.get(
              '$baseURL/orders/history?status=${status.toLowerCase()}&limit=$limit&page=$page',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: {
                'data': [],
                'message': 'Failed to load Order',
              }, statusCode: 404, requestOptions: RequestOptions(path: '')));

      expect(
          () async => dataSource.getOrders(
              userId: userId, status: status, page: page, limit: limit),
          throwsA(isA<ServerException>()));
    });
  });

  group('test getPendingOrdersCount', () {
    final String userId = '123';
    final String status = 'pending';

    test('getPendingOrdersCount should return count on success', () async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);

      when(mockDio.get('$baseURL/orders/orders-count?status=pending',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: {
                'data': 5,
              }, statusCode: 200, requestOptions: RequestOptions(path: '')));

      final result = await dataSource.getPendingOrdersCount(
          userId: userId, status: status);

      expect(result, 5);
    });

    test('get PendingOrdersCount should return ServerEXception on Error',
        () async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);
      when(mockDio.get('$baseURL/orders/orders-count?status=pending',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: {
                'data': 0,
                'message': 'Failed to load Order',
              }, statusCode: 404, requestOptions: RequestOptions(path: '')));

      expect(
        () async =>
            dataSource.getPendingOrdersCount(userId: userId, status: status),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('test getOrderDetail', () {
    final String orderId = '123';
    final responseJson = {
      "id": "order_12345",
      "restaurant_id": "restaurant_54321",
      "restaurant_name": "The Great Restaurant",
      "order_status": "completed",
      "order_type": "dine-in",
      "total_price": 2500,
      "total_number_of_items": 5,
      "estimated_waiting_time": 30,
      "order_message": "Please deliver to the side door.",
      "createdAt": "2025-02-18T12:34:56.789Z",
      "updatedAt": "2025-02-18T13:45:67.890Z",
      "order_items": [
        {
          "id": "item_1",
          "item_id": "item_123",
          "quantity": 2,
          "item": {
            "name": "Burger",
            "price": 500,
            "item_images": [
              {"url": "https://example.com/images/burger.jpg"}
            ]
          }
        },
        {
          "id": "item_2",
          "item_id": "item_456",
          "quantity": 1,
          "item": {
            "name": "Fries",
            "price": 200,
            "item_images": [
              {"url": "https://example.com/images/fries.jpg"}
            ]
          }
        },
        {
          "id": "item_3",
          "item_id": "item_789",
          "quantity": 2,
          "item": {
            "name": "Soda",
            "price": 150,
            "item_images": [
              {"url": "https://example.com/images/soda.jpg"}
            ]
          }
        }
      ],
      "order_confirmed_at": "2025-02-18T12:45:00.000Z",
      "payment_confirmed_at": "2025-02-18T12:50:00.000Z",
      "order_placed_at": "2025-02-18T12:30:00.000Z",
      "order_completed_at": "2025-02-18T13:00:00.000Z",
      "order_rejected_at": null,
      "order_cancelled_at": null
    };
    test('getOrderDetail should return OrderDetailModel on success', () async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);

      when(mockDio.get('$baseURL/orders/$orderId',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                  data: {
                    'data': responseJson,
                  }));

      final result = await dataSource.getOrderDetail(orderId: orderId);
      expect(result, OrderDetailModel.fromJson(responseJson));
    });

    test('ggetOrderDetail should return ServerException on error', () async {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);

      when(mockDio.get('$baseURL/orders/$orderId',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 404,
                  data: {
                    'message': 'Failed to load Order',
                  }));

      final result = dataSource.getOrderDetail(orderId: orderId);
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
