import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../features.dart';

class GeTagSuggestionUseCase
    extends UseCase<List<ItemCategoryModel>, NoParams> {
  final FoodCategoryRepository repository;
  GeTagSuggestionUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ItemCategoryModel>>> call(NoParams params) async {
    return await repository.getTagSuggestion();
  }
}
