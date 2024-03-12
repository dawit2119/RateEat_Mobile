import 'package:equatable/equatable.dart';

class FeedBackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitFeedbackEvent extends FeedBackEvent {
  final String comment;
  SubmitFeedbackEvent({required this.comment});
  @override
  List<Object?> get props => [comment];
}
