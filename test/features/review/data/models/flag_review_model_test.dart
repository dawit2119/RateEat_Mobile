import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/review/data/models/flag_review_model.dart';

void main() {
  group('FlagReviewModel', () {
    test('fromJson should return a valid FlagReviewModel', () {
      // Arrange
      final json = {
        "report_type": "spam",
        "review_id": "review123",
        "user_id": "user456",
        "text": "This review is not helpful."
      };

      // Act
      final result = FlagReviewModel.fromJson(json);

      // Assert
      expect(result.reportType, "spam");
      expect(result.reviewId, "review123");
      expect(result.userId, "user456");
      expect(result.text, "This review is not helpful.");
    });

    test('fromJson should handle missing fields gracefully', () {
      // Arrange
      final json = {
        "report_type": "spam",
        "review_id": "review123",
        "user_id": "user456",
        // 'text' is missing
      };

      // Act
      final result = FlagReviewModel.fromJson(json);

      // Assert
      expect(result.reportType, "spam");
      expect(result.reviewId, "review123");
      expect(result.userId, "user456");
      expect(result.text, null); // text should be null if missing
    });
  });
}
