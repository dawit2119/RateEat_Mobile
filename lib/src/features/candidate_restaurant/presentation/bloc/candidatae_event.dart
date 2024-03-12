import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';

abstract class CandidateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitCandidate extends CandidateEvent {
  final CandidRest candidRest;
  SubmitCandidate({required this.candidRest});
}
