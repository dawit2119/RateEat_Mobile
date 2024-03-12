import 'package:equatable/equatable.dart';

abstract class CandidateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CandidateInitial extends CandidateState {}

class CandidateLoading extends CandidateState {}

class CandidateSuccess extends CandidateState {
  final String message;
  CandidateSuccess({required this.message});
}

class CandidateFailure extends CandidateState {
  final String error;
  CandidateFailure({required this.error});
}
