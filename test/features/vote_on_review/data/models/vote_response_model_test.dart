import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/models/review_model.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/models/vote_response_model.dart';

void main() {
  final reviewModel = ReviewOnVoteModel(
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

  final voteResponseModel = VoteResponseModel(
    message: 'Vote recorded successfully',
    review: reviewModel,
  );

  group('VoteResponseModel', () {
    test('should create a VoteResponseModel from a map', () {
      // Arrange
      final map = {
        'message': 'Vote recorded successfully',
        'review': {
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
        },
      };

      // Act
      final model = VoteResponseModel.fromMap(map);

      // Assert
      expect(model, voteResponseModel);
    });

    test('should convert VoteResponseModel to a map', () {
      // Act
      final map = voteResponseModel.toMap();

      // Assert
      expect(map, {
        'message': 'Vote recorded successfully',
        'review': reviewModel.toMap(),
      });
    });

    test('should create a VoteResponseModel from JSON', () {
      // Arrange
      final jsonString = json.encode({
        'message': 'Vote recorded successfully',
        'review': {
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
        },
      });

      // Act
      final model = VoteResponseModel.fromJson(jsonString);

      // Assert
      expect(model, voteResponseModel);
    });

    test('should convert VoteResponseModel to JSON', () {
      // Act
      final jsonString = voteResponseModel.toJson();

      // Assert
      expect(json.decode(jsonString), {
        'message': 'Vote recorded successfully',
        'review': reviewModel.toMap(),
      });
    });

    test('should copy the model with new values', () {
      // Act
      final updatedModel =
          voteResponseModel.copyWith(message: 'Updated message');

      // Assert
      expect(updatedModel.message, 'Updated message');
      expect(updatedModel.review,
          voteResponseModel.review); // review should remain the same
    });
  });
}
