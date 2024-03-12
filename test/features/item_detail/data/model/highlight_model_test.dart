import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';

void main() {
  group('HighlightModel', () {
    test('creates HighlightModel correctly', () {
      const highlight = HighlightModel(
        url: 'https://example.com/image.jpg',
        media: MediaType.image,
        duration: Duration(seconds: 5),
      );

      expect(highlight.url, 'https://example.com/image.jpg');
      expect(highlight.media, MediaType.image);
      expect(highlight.duration, Duration(seconds: 5));
    });
  });

  group('mapToHighlightModels', () {
    test('maps image URLs to HighlightModels', () {
      final imageUrls = [
        {'url': 'https://example.com/image1.jpg'},
        {'url': 'https://example.com/image2.jpg'},
      ];
      final videoUrls = [];

      final result = mapToHighlightModels(imageUrls, videoUrls);

      expect(result.length, 2);
      expect(result[0].url, 'https://example.com/image1.jpg');
      expect(result[0].media, MediaType.image);
      expect(result[1].url, 'https://example.com/image2.jpg');
      expect(result[1].media, MediaType.image);
    });

    test('maps video URLs to HighlightModels', () {
      final imageUrls = [];
      final videoUrls = [
        'https://example.com/video1.mp4',
        'https://example.com/video2.mp4'
      ];

      final result = mapToHighlightModels(imageUrls, videoUrls);

      expect(result.length, 2);
      expect(result[0].url, 'https://example.com/video1.mp4');
      expect(result[0].media, MediaType.video);
      expect(result[1].url, 'https://example.com/video2.mp4');
      expect(result[1].media, MediaType.video);
    });

    test('returns default HighlightModel when no inputs', () {
      final imageUrls = [];
      final videoUrls = [];

      final result = mapToHighlightModels(imageUrls, videoUrls);

      expect(result.length, 1);
      expect(result[0].url,
          'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg');
      expect(result[0].media, MediaType.image);
    });
  });
}
