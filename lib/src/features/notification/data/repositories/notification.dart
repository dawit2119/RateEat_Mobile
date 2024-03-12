import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../domain/entities/notification.dart';

import '../../domain/repositories/notification.dart';
import '../data_sources/notification.dart';

class NotificationsRepositoryImpl extends NotificationsRepository {
  final NotificationsRemoteDataSource notificationRemoteDataSource;
  NotificationsRepositoryImpl({
    required this.notificationRemoteDataSource,
  });
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required String userId,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await notificationRemoteDataSource.getUserNotifications(
        userId: userId,
        page: page,
        limit: limit,
      );
      return Right(
        response,
      );
    } on SocketException {
      return Left(
        NetworkFailure(),
      );
    } catch (e) {
      return Left(
        ServerFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markNotificationAsRead(
      {required String notificationId}) async {
    try {
      var response = await notificationRemoteDataSource.markNotificationAsRead(
        notificationId: notificationId,
      );
      return Right(
        response,
      );
    } on SocketException {
      return Left(
        NetworkFailure(),
      );
    } catch (e) {
      return Left(
        ServerFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getUnReadNotificationsCount(
      {required String userId}) async {
    try {
      var response =
          await notificationRemoteDataSource.getUnreadNotificationsCount(
        userId: userId,
      );
      return Right(
        response,
      );
    } on SocketException {
      return Left(
        NetworkFailure(),
      );
    } catch (e) {
      return Left(
        ServerFailure(),
      );
    }
  }
}
