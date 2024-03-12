import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CandidateItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddCandidateItemEvent extends CandidateItemEvent {
  final String itemName;
  final double price;
  final List<File> itemImages;
  final String menuId;
  final String categoryName;

  AddCandidateItemEvent({
    required this.itemName,
    required this.price,
    required this.itemImages,
    required this.menuId,
    required this.categoryName,
  });
}
