import 'package:rateeat_mobile/src/features/features.dart';

class QRCategoryModel extends QRCategory {
  const QRCategoryModel(
      {required super.id, required super.name, required super.imageUri});
  factory QRCategoryModel.fromMap(data) => QRCategoryModel(
        id: data['id'] ?? "",
        name: data['name'] ?? "",
        imageUri: data['imageUri'] ?? "",
      );
}
