import 'package:equatable/equatable.dart';

import '../../../../homepage/domain/entities/item.dart';

abstract class CandidateItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddCandidateItemInitial extends CandidateItemState {}

class AddCandidateItemLoading extends CandidateItemState {}

class CandidateItemAdded extends CandidateItemState {
  final Item candidateItem;

  CandidateItemAdded({
    required this.candidateItem,
  });
  @override
  List<Object?> get props => [candidateItem];
}

class CandidateItemAddFailed extends CandidateItemState {
  final String message;

  CandidateItemAddFailed({required this.message});
  @override
  List<Object?> get props => [message];
}
