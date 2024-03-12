import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class QRMenuState extends Equatable {
  final int? minRating;
  final String? sortBy;
  final String sortType;
  final int? minPrice;
  final int? maxPrice;

  const QRMenuState(
      {required this.minPrice,
      required this.maxPrice,
      required this.minRating,
      required this.sortBy,
      required this.sortType});
}

class QRMenuInitial extends QRMenuState {
  const QRMenuInitial(
      {required super.minPrice,
      required super.maxPrice,
      required super.minRating,
      required super.sortBy,
      required super.sortType});

  @override
  List<Object?> get props => [minPrice, maxPrice, minRating, sortBy, sortType];
}

class QRMenuLoaded extends QRMenuState {
  final QRMenuModel menu;
  final int page;
  final bool hasReachedMax;

  const QRMenuLoaded({
    required this.menu,
    required this.page,
    required this.hasReachedMax,
    required super.minPrice,
    required super.maxPrice,
    required super.minRating,
    required super.sortBy,
    required super.sortType,
  });

  @override
  List<Object?> get props => [
        menu,
        page,
        hasReachedMax,
        minPrice,
        maxPrice,
        minRating,
        sortBy,
        sortType
      ];
}

class QRMenuFailed extends QRMenuState {
  const QRMenuFailed(
      {required super.minPrice,
      required super.maxPrice,
      required super.minRating,
      required super.sortBy,
      required super.sortType});

  @override
  List<Object?> get props => [minPrice, maxPrice, minRating, sortBy, sortType];
}

class QRMenuLoading extends QRMenuState {
  final QRMenuModel? menu;
  const QRMenuLoading(
      {this.menu,
      required super.minPrice,
      required super.maxPrice,
      required super.minRating,
      required super.sortBy,
      required super.sortType});

  @override
  List<Object?> get props => [minPrice, maxPrice, minRating, sortBy, sortType];
}

class QRMenuNextLoading extends QRMenuState {
  final QRMenuModel menu;
  const QRMenuNextLoading(
      {required this.menu,
      required super.minPrice,
      required super.maxPrice,
      required super.minRating,
      required super.sortBy,
      required super.sortType});

  @override
  List<Object?> get props =>
      [menu, minPrice, maxPrice, minRating, sortBy, sortType];
}
