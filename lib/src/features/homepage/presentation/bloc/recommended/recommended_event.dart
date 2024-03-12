part of 'recommended_bloc.dart';

abstract class RecommendedEvent extends Equatable {
  const RecommendedEvent();

  @override
  List<Object> get props => [];
}

class GetRecommendedEvent extends RecommendedEvent {
  final int page;
  final int limit;
  final double? latitude;
  final double? longitude;
  final List<String> tags;

  const GetRecommendedEvent({
    this.page = 1,
    this.limit = 7,
    this.latitude,
    this.longitude,
    required this.tags,
  });

  @override
  List<Object> get props => [page, limit, tags];
}
