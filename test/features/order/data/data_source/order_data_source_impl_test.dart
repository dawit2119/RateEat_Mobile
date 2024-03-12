import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/order/data/data_sources/order_data_source.dart';
import 'package:rateeat_mobile/src/features/order/data/models/order_item_model.dart';
import 'package:rateeat_mobile/src/features/order/data/models/order_model.dart';
import 'package:rateeat_mobile/src/features/order/data/models/total_price_model.dart';
import 'package:rateeat_mobile/src/features/order/data/models/payment_request_model.dart';

import 'order_data_source_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AuthenticationLocalSourceImpl>()])
void main() {
  late OrderDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockAuthenticationLocalSourceImpl mockAuthLocalSource;
  late String baseUrl;
  final testUser = LocalUserModel(token: 'test_token');

  setUp(() async {
    await dotenv.load(fileName: '.env');
    baseUrl = dotenv.get('BASE_URL');
    mockDio = MockDio();
    mockAuthLocalSource = MockAuthenticationLocalSourceImpl();

    // Proper dependency setup
    dpLocator.registerSingleton<AuthenticationLocalSource>(mockAuthLocalSource);

    dataSource = OrderDataSourceImpl(dio: mockDio);
  });

  tearDown(() {
    dpLocator.reset();
  });

  group('getTotalPrice', () {
    final testCart = {
      Item(
        itemId: '1',
        itemName: 'Test Item',
        numberOfReviews: 10,
        description: 'A delicious test item',
        averageRating: 4.5,
        price: 10.0,
        restaurantName: 'Test Restaurant',
        imageUrl: 'https://example.com/image1.jpg',
        itemImages: [ItemMedia(id: '2', url: 'https://example.com/image1.jpg')],
        itemVideos: [ItemMedia(id: '3', url: 'https://example.com/video1.mp4')],
        tags: ['tag1', 'tag2'],
        categoryId: 'cat1',
        fasting: false,
        priceUpdatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ingredients: [Ingredient(id: '1', name: 'Ingredient1')],
        categories: Categories(menuId: 'Category1'),
        minutes: 30,
        isOpen: true,
        isFavorite: false,
        distance: '5km',
        ridingTime: '10min',
        walkingTime: '30min',
      ): 2,
      Item(
        itemId: '5',
        itemName: 'Test Item',
        numberOfReviews: 10,
        description: 'A delicious test item',
        averageRating: 4.5,
        price: 10.0,
        restaurantName: 'Test Restaurant',
        imageUrl: 'https://example.com/image1.jpg',
        itemImages: [ItemMedia(id: '2', url: 'https://example.com/image1.jpg')],
        itemVideos: [ItemMedia(id: '3', url: 'https://example.com/video1.mp4')],
        tags: ['tag1', 'tag2'],
        categoryId: 'cat1',
        fasting: false,
        priceUpdatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ingredients: [Ingredient(id: '1', name: 'Ingredient1')],
        categories: Categories(menuId: 'Category1'),
        minutes: 30,
        isOpen: true,
        isFavorite: false,
        distance: '5km',
        ridingTime: '10min',
        walkingTime: '30min',
      ): 3,
    };

    test('should return TotalPriceModel when request is successful', () async {
      // Arrange
      const expectedData = {'totalItems': 5, 'totalPrice': 65.0};

      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.post(
        '$baseUrl/orders/calculate-total-price/items',
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {'data': expectedData},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await dataSource.getTotalPrice(testCart);

      // Assert
      final capturedOptions = verify(mockDio.post(
        '$baseUrl/orders/calculate-total-price/items',
        data: anyNamed('data'),
        options: captureAnyNamed('options'),
      )).captured.single as Options;

      expect(capturedOptions.headers?['Authorization'],
          'Bearer Authorization${testUser.token}');
      expect(result, equals(TotalPriceModel(totalItems: 5, totalPrice: 65.0)));
    });
    test('should throw ServerException when response is not 200', () async {
      // Arrange
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: {'message': 'Invalid items'},
                statusCode: 400,
                requestOptions: RequestOptions(path: ''),
              ));

      // Act & Assert
      expect(() async => await dataSource.getTotalPrice(testCart),
          throwsA(isA<ServerException>()));
    });
  });

  group('test create order', () {
    final testOrder = OrderModel(
      id: '1',
      restaurantId: '1',
      restaurantName: 'Test Restaurant',
      orderStatus: 'pending',
      orderType: 'delivery',
      orderCanceledAt: DateTime.now(),
      orderCompletedAt: DateTime.now(),
      orderConfirmedAt: DateTime.now(),
      orderPlacedAt: DateTime.now(),
      orderRejectedAt: DateTime.now(),
      totalPrice: 65.0,
      totalNumberOfItems: 1,
      estimatedWaitingTime: 30,
      orderMessage: 'Test order',
      orderItems: [
        OrderItemModel(itemId: '1', quantity: 2),
        OrderItemModel(itemId: '5', quantity: 3),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final responseData = {
      'id': '1',
      'restaurant_id': '1',
      'restaurant_name': 'Test Restaurant',
      'order_status': 'pending',
      'order_type': 'delivery',
      'total_price': 65.0,
      'total_number_of_items': 1,
      'estimated_waiting_time': 30,
      'order_message': 'Test order',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'order_items': [
        {
          'item_id': '1',
          'item_name': 'Test Item 1',
          'item_price': 10.0,
          'quantity': 2,
          'total_price': 20.0,
          'item_image': 'https://example.com/image1.jpg',
        },
        {
          'item_id': '5',
          'item_name': 'Test Item 5',
          'item_price': 15.0,
          'quantity': 3,
          'total_price': 45.0,
          'item_image': 'https://example.com/image5.jpg',
        },
      ],
      'order_confirmed_at': DateTime.now().toIso8601String(),
      'payment_confirmed_at': DateTime.now().toIso8601String(),
      'order_placed_at': DateTime.now().toIso8601String(),
      'order_completed_at': DateTime.now().toIso8601String(),
      'order_rejected_at': DateTime.now().toIso8601String(),
      'order_cancelled_at': DateTime.now().toIso8601String(),
    };

    test('create order should return Order Model on 201', () async {
      // Arrange
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.post(
        '$baseUrl/orders',
        data: testOrder.toJson(),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 201,
              data: {
                'data': responseData,
              }));

      // Act
      final result = await dataSource.createOrder(testOrder);

      // Assert
      final capturedOptions = verify(mockDio.post(
        '$baseUrl/orders',
        data: anyNamed('data'),
        options: captureAnyNamed('options'),
      )).captured.single as Options;
      expect(capturedOptions.headers?['Authorization'],
          'Bearer ${testUser.token}');
      expect(result, equals(OrderModel.fromJson(responseData)));
    });

    test('create order should throw ServerException on 400', () async {
      // Arrange
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.post(
        '$baseUrl/orders',
        data: testOrder.toJson(),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
              data: {
                'message': 'Failed to create Order',
              }));

      // Act & Assert
      expect(() async => await dataSource.createOrder(testOrder),
          throwsA(isA<ServerException>()));
    });
  });

  group('test pay', () {
    final testPaymentInfo = PaymentRequestModel(
        orderId: '1', firstName: 'Abrham', lastName: 'Lakew');

    final responseData = {
      'payment_url': 'https://example.com/payment',
    };

    test('pay should return payment Url on 200', () async {
      // ArrangetestPaymentInfo.toJson()
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.post(
        '$baseUrl/payments/pay',
        data: json.encode(testPaymentInfo.toJson()),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {
                'data': responseData,
              }));

      // Act
      final result = await dataSource.pay(paymentInfo: testPaymentInfo);

      // Assert
      final capturedOptions = verify(mockDio.post(
        '$baseUrl/payments/pay',
        data: anyNamed('data'),
        options: captureAnyNamed('options'),
      )).captured.single as Options;
      expect(capturedOptions.headers?['Authorization'],
          'Bearer ${testUser.token}');
      expect(result, equals(responseData['payment_url']));
    });

    test('pay should throw ServerException on 400', () async {
      // Arrange
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.post(
        '$baseUrl/payments/pay',
        data: json.encode(testPaymentInfo.toJson()),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
              data: {
                'message': 'Failed to pay',
              }));

      // Act & Assert
      expect(() async => await dataSource.pay(paymentInfo: testPaymentInfo),
          throwsA(isA<ServerException>()));
    });
  });

  group('cancel order test', () {
    final orderId = '1';
    final reason = 'I changed my mind';

    test('cancel order should return true on 200', () async {
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.put(
        '$baseUrl/orders/$orderId/cancel-order',
        data: json.encode({'reason': reason}),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {
                'message': 'Order cancelled successfully',
              }));

      // Act
      final result =
          await dataSource.cancelOrder(orderId: orderId, reason: reason);
      expect(result, true);
    });

    test('cancel order should return', () async {
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.put(
        '$baseUrl/orders/$orderId/cancel-order',
        data: json.encode({'reason': reason}),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
              data: {
                'message': 'Failed to cancel order',
              }));

      // Act & Assert
      expect(
          () async =>
              await dataSource.cancelOrder(orderId: orderId, reason: reason),
          throwsA(isA<ServerException>()));
    });
  });

  group('test getOrderStatus', () {
    final responseData = {
      'id': '1',
      'restaurant_id': '1',
      'restaurant_name': 'Test Restaurant',
      'order_status': 'pending',
      'order_type': 'delivery',
      'total_price': 65.0,
      'total_number_of_items': 1,
      'estimated_waiting_time': 30,
      'order_message': 'Test order',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'order_items': [
        {
          'item_id': '1',
          'item_name': 'Test Item 1',
          'item_price': 10.0,
          'quantity': 2,
          'total_price': 20.0,
          'item_image': 'https://example.com/image1.jpg',
        },
        {
          'item_id': '5',
          'item_name': 'Test Item 5',
          'item_price': 15.0,
          'quantity': 3,
          'total_price': 45.0,
          'item_image': 'https://example.com/image5.jpg',
        },
      ],
      'order_confirmed_at': DateTime.now().toIso8601String(),
      'payment_confirmed_at': DateTime.now().toIso8601String(),
      'order_placed_at': DateTime.now().toIso8601String(),
      'order_completed_at': DateTime.now().toIso8601String(),
      'order_rejected_at': DateTime.now().toIso8601String(),
      'order_cancelled_at': DateTime.now().toIso8601String(),
    };

    test('get order status should return orderModel on success', () async {
      final orderId = '1';
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.get('$baseUrl/orders/$orderId',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 200,
                  data: {
                    'data': responseData,
                  }));

      // Act
      final result = await dataSource.getOrderStatus(orderId: orderId);
      expect(result, equals(OrderModel.fromJson(responseData)));
    });

    test('get order status should throw ServerException on 400', () async {
      final String orderId = '1';
      when(mockAuthLocalSource.getUserCredential()).thenReturn(testUser);
      when(mockDio.get('$baseUrl/orders/$orderId',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 400,
                  data: {
                    'message': 'Failed to get order status',
                  }));

      // Act & Assert
      expect(() async => await dataSource.getOrderStatus(orderId: orderId),
          throwsA(isA<ServerException>()));
    });
  });
}
