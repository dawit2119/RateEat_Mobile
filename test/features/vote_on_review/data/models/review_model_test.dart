import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/models/review_model.dart';

void main() {
  final reviewOnVoteModel = ReviewOnVoteModel(
    id: '1',
    itemId: 'item123',
    userId: 'user123',
    rating: 4.5,
    comment: 'Great!',
    upVote: 10,
    downVote: 2,
    visibility: true,
    createdAt: DateTime.parse('2023-01-01T12:00:00Z'),
    updatedAt: DateTime.parse('2023-01-02T12:00:00Z'),
    voted: 1,
  );

  group('ReviewOnVoteModel', () {
    test('should create a ReviewOnVoteModel from a map', () {
      // Arrange
      final map = {
        'id': '1',
        'item_id': 'item123',
        'user_id': 'user123',
        'rating': 4.5,
        'comment': 'Great!',
        'up_vote': 10,
        'down_vote': 2,
        'visibility': true,
        'createdAt': '2023-01-01T12:00:00Z',
        'updatedAt': '2023-01-02T12:00:00Z',
        'voted': 1,
      };

      // Act
      final model = ReviewOnVoteModel.fromMap(map);

      // Assert
      expect(model, reviewOnVoteModel);
    });

    test('should convert ReviewOnVoteModel to a map', () {
      // Act
      final map = reviewOnVoteModel.toMap();

      // Assert
      expect(map, {
        'id': '1',
        'item_id': 'item123',
        'user_id': 'user123',
        'rating': 4.5,
        'comment': 'Great!',
        'up_vote': 10,
        'down_vote': 2,
        'visibility': true,
        'createdAt': '2023-01-01T12:00:00.000Z',
        'updatedAt': '2023-01-02T12:00:00.000Z',
        'voted': 1,
      });
    });

    test('should create a ReviewOnVoteModel from JSON', () {
      // Arrange
      final jsonString = json.encode({
        'id': '1',
        'item_id': 'item123',
        'user_id': 'user123',
        'rating': 4.5,
        'comment': 'Great!',
        'up_vote': 10,
        'down_vote': 2,
        'visibility': true,
        'createdAt': '2023-01-01T12:00:00Z',
        'updatedAt': '2023-01-02T12:00:00Z',
        'voted': 1,
      });

      // Act
      final model = ReviewOnVoteModel.fromJson(jsonString);

      // Assert
      expect(model, reviewOnVoteModel);
    });

    test('should convert ReviewOnVoteModel to JSON', () {
      // Act
      final jsonString = reviewOnVoteModel.toJson();

      // Assert
      expect(json.decode(jsonString), {
        'id': '1',
        'item_id': 'item123',
        'user_id': 'user123',
        'rating': 4.5,
        'comment': 'Great!',
        'up_vote': 10,
        'down_vote': 2,
        'visibility': true,
        'createdAt': '2023-01-01T12:00:00.000Z',
        'updatedAt': '2023-01-02T12:00:00.000Z',
        'voted': 1,
      });
    });

    test('should copy the model with new values', () {
      // Act
      final updatedModel =
          reviewOnVoteModel.copyWith(rating: 5.0, comment: 'Excellent!');

      // Assert
      expect(updatedModel.rating, 5.0);
      expect(updatedModel.comment, 'Excellent!');
      expect(updatedModel.id,
          reviewOnVoteModel.id); // other fields should remain the same
    });
  });
}
