import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class CheckUserNameAvailabilityUseCase extends UseCase<bool, QueryParams> {
  final ProfileRepository profileRepository;

  CheckUserNameAvailabilityUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, bool>> call(QueryParams params) async {
    return await profileRepository.checkUsernameAvailability(
        userName: params.userName);
  }
}

class QueryParams extends Equatable {
  final String userName;
  const QueryParams({required this.userName});

  @override
  List<Object?> get props => [userName];
}
