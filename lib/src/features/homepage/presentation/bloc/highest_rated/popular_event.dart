import 'package:equatable/equatable.dart';

abstract class PopularEvent extends Equatable {
  const PopularEvent();
  @override
  List<Object> get props => [];
}

class GetTopRatedEvent extends PopularEvent {
  final int page;
  final int limit;
  final double? lat;
  final double? lng;
  final List<String> tags;
  final bool? isFasting;
  const GetTopRatedEvent({
    required this.tags,
    required this.page,
    this.limit = 7,
    this.lat,
    this.lng,
    this.isFasting,
  });

  @override
  List<Object> get props => [page, limit, tags];
}

class GetFilteredTopRatedEvent extends PopularEvent {
  final int page;
  final int limit;
  final double? lat;
  final double? lng;
  final String tag;
  final String filter;
  const GetFilteredTopRatedEvent({
    required this.tag,
    required this.page,
    required this.filter,
    this.limit = 7,
    this.lat,
    this.lng,
  });

  @override
  List<Object> get props => [page, limit, tag, filter];
}

class ResetTopRatedEvent extends PopularEvent {}
