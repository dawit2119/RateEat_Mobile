import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/core.dart';

import '../../domain.dart';

class EditProfileUseCase extends UseCase<User, EditProfileUseCaseParams> {
  final ProfileRepository profileRepository;

  EditProfileUseCase({
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, User>> call(EditProfileUseCaseParams params) async {
    return await profileRepository.editProfile(
      user: params.user,
      updateData: params.updateData,
    );
  }
}

class EditProfileUseCaseParams extends Equatable {
  final User user;
  final Map<String, dynamic> updateData;

  const EditProfileUseCaseParams({
    required this.user,
    required this.updateData,
  });

  @override
  List<Object?> get props => [user, updateData];
}
