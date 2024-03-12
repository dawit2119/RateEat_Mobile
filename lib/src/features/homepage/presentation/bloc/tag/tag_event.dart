import 'package:equatable/equatable.dart';

abstract class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object> get props => [];
}

class SelectTag extends TagEvent {
  final String tag;
  const SelectTag({required this.tag});

  @override
  List<Object> get props => [tag];
}

class UnselectTag extends TagEvent {
  final String tag;
  const UnselectTag({required this.tag});

  @override
  List<Object> get props => [tag];
}
