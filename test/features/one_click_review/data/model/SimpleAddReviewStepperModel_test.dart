import 'package:rateeat_mobile/src/features/one_click_review/data/models/simple_review_stepper_model.dart';
import 'package:test/test.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';

void main() {
  group('SimpleAddReviewStepperModel', () {
    final testImages = [
      XFile('path/to/image1.jpg'),
      XFile('path/to/image2.jpg')
    ];
    final testVideos = [XFile('path/to/video1.mp4')];
    final testItem =
        NearByItemResponse(id: 'item1', name: 'Test Item', imageUri: 'uri');
    final testRestaurant = NearByRestaurantResponse(
      id: 'rest1',
      name: 'Test Restaurant',
      currency: 'USD',
    );

    // Test instance
    final testModel = SimpleAddReviewStepperModel(
      images: testImages,
      videos: testVideos,
      item: testItem,
      restaurant: testRestaurant,
    );

    test('should be a subclass of Equatable', () {
      expect(testModel, isA<Equatable>());
    });

    group('constructor', () {
      test('should create instance with all properties', () {
        expect(testModel.images, testImages);
        expect(testModel.videos, testVideos);
        expect(testModel.item, testItem);
        expect(testModel.restaurant, testRestaurant);
      });

      test('should create instance with null properties', () {
        final emptyModel = SimpleAddReviewStepperModel();

        expect(emptyModel.images, isNull);
        expect(emptyModel.videos, isNull);
        expect(emptyModel.item, isNull);
        expect(emptyModel.restaurant, isNull);
      });
    });

    group('copyWith', () {
      test('should create copy with updated values', () {
        final newImages = [XFile('path/to/newimage.jpg')];
        final newVideos = [XFile('path/to/newvideo.mp4')];
        final newItem = NearByItemResponse(
            id: 'item2', name: 'New Item', imageUri: 'newuri');
        final newRestaurant = NearByRestaurantResponse(
          id: 'rest2',
          name: 'New Restaurant',
          currency: 'EUR',
        );

        final copy = testModel.copyWith(
          images: newImages,
          videos: newVideos,
          item: newItem,
          restaurant: newRestaurant,
        );

        expect(copy.images, newImages);
        expect(copy.videos, newVideos);
        expect(copy.item, newItem);
        expect(copy.restaurant, newRestaurant);
      });
    });

    group('props', () {
      test('should return correct list of properties', () {
        expect(testModel.props,
            [testImages, testVideos, testItem, testRestaurant]);
      });

      test('should return list with null values when properties are null', () {
        final emptyModel = SimpleAddReviewStepperModel();
        expect(emptyModel.props, [null, null, null, null]);
      });
    });

    group('equality', () {
      test('should be equal when all properties match', () {
        final identicalModel = SimpleAddReviewStepperModel(
          images: testImages,
          videos: testVideos,
          item: testItem,
          restaurant: testRestaurant,
        );

        expect(testModel, equals(identicalModel));
      });

      test('should not be equal when properties differ', () {
        final differentModel = SimpleAddReviewStepperModel(
          images: [XFile('different/path.jpg')],
          videos: testVideos,
          item: testItem,
          restaurant: testRestaurant,
        );

        expect(testModel, isNot(equals(differentModel)));
      });
    });
  });
}
