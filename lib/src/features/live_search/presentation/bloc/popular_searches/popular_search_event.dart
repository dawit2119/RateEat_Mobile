import 'package:equatable/equatable.dart';

abstract class PopularSearchesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPopularSearches extends PopularSearchesEvent {
  final int limit;
  final int page;

  GetPopularSearches({
    required this.limit,
    required this.page,
  });
  @override
  List<Object> get props => [
        limit,
        page,
      ];
}
