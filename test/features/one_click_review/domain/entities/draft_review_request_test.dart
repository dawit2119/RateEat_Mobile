import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/draft_review_request.dart';

void main() {
  group('DraftReviewRequest', () {
    // Test data
    const tItemId = 'item123';
    const tRestaurantId = 'rest456';
    final tImages = [XFile('path/to/image1.jpg'), XFile('path/to/image2.jpg')];
    final tVideos = [XFile('path/to/video1.mp4')];

    // Test instances
    final fullRequest = DraftReviewRequest(
      itemId: tItemId,
      restaurantId: tRestaurantId,
      images: tImages,
      videos: tVideos,
    );
    final minimalRequest = DraftReviewRequest(
      itemId: tItemId,
      restaurantId: tRestaurantId,
    );

    group('constructor', () {
      test('should create instance with all properties', () {
        expect(fullRequest.itemId, tItemId);
        expect(fullRequest.restaurantId, tRestaurantId);
        expect(fullRequest.images, tImages);
        expect(fullRequest.videos, tVideos);
      });

      test(
          'should create instance with null optional properties when not provided',
          () {
        expect(minimalRequest.itemId, tItemId);
        expect(minimalRequest.restaurantId, tRestaurantId);
        expect(minimalRequest.images, isNull);
        expect(minimalRequest.videos, isNull);
      });
    });

    group('copyWith', () {
      test('should create copy with updated values', () {
        const newItemId = 'item789';
        const newRestaurantId = 'rest101';
        final newImages = [XFile('path/to/newimage.jpg')];
        final newVideos = [XFile('path/to/newvideo.mp4')];

        final copy = fullRequest.copyWith(
          itemId: newItemId,
          restaurantId: newRestaurantId,
          images: newImages,
          videos: newVideos,
        );

        expect(copy.itemId, newItemId);
        expect(copy.restaurantId, newRestaurantId);
        expect(copy.images, newImages);
        expect(copy.videos, newVideos);
      });

      test('should keep original values when not specified', () {
        final copy = fullRequest.copyWith();

        expect(copy.itemId, tItemId);
        expect(copy.restaurantId, tRestaurantId);
        expect(copy.images, tImages);
        expect(copy.videos, tVideos);
      });

      test('should update only specified fields', () {
        const newItemId = 'item999';
        final copy = fullRequest.copyWith(itemId: newItemId);

        expect(copy.itemId, newItemId);
        expect(copy.restaurantId, tRestaurantId);
        expect(copy.images, tImages);
        expect(copy.videos, tVideos);
      });
    });

    group('equality', () {
      test('should not be equal when properties differ', () {
        final differentItemId = DraftReviewRequest(
          itemId: 'different123',
          restaurantId: tRestaurantId,
          images: tImages,
          videos: tVideos,
        );
        final differentImages = DraftReviewRequest(
          itemId: tItemId,
          restaurantId: tRestaurantId,
          images: [XFile('different/path.jpg')],
          videos: tVideos,
        );

        expect(fullRequest, isNot(equals(differentItemId)));
        expect(fullRequest, isNot(equals(differentImages)));
      });
    });
  });
}
