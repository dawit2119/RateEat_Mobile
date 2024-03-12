import 'package:rateeat_mobile/src/features/notification/data/models/notification.dart';
import 'package:rateeat_mobile/src/features/notification/domain/entities/notification.dart';
import 'package:test/test.dart';

void main() {
  group('NotificationModel', () {
    test('fromMap creates a NotificationModel', () {
      final json = {
        'id': "1",
        'notifiable_type': 'ItemReview',
        'createdAt': '2022-01-01T00:00:00.000Z',
        'read_status': true,
        'message': 'Test message',
        'reactor': {
          'first_name': 'Test',
          'last_name': 'User',
          'image': 'https://example.com/image.jpg',
        },
        'item_review': {
          'id': "1",
          'item_id': "1",
          'user_id': "1",
          'rating': 5.0,
          'comment': 'Great item!',
          'createdAt': '2022-01-01T00:00:00.000Z',
        },
      };

      final model = NotificationModel.fromMap(json);

      expect(model.id, "1");
      expect(model.notifiableType, NotificationType.itemReview);
      expect(model.createdAt, DateTime.parse('2022-01-01T00:00:00.000Z'));
      expect(model.readStatus, true);
      expect(model.message, 'Test message');
      expect(model.reactor.firstName, 'Test');
      expect(model.reactor.lastName, 'User');
      expect(model.reactor.profileImageUrl, 'https://example.com/image.jpg');
      expect(model.targetReview?.id, "1");
      expect(model.targetReview?.notifiableId, "1");
      expect(model.targetReview?.userId, "1");
      expect(model.targetReview?.rating, 5.0);
      expect(model.targetReview?.comment, 'Great item!');
      expect(model.targetReview?.createdAt,
          DateTime.parse('2022-01-01T00:00:00.000Z'));
    });
  });
}
