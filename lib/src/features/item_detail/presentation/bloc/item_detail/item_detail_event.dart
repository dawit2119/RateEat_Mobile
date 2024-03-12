import 'package:equatable/equatable.dart';

class ItemDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetItemDetailEvent extends ItemDetailEvent {
  final String itemId;
  GetItemDetailEvent({required this.itemId});
  @override
  List<Object?> get props => [itemId];
}
