import 'package:equatable/equatable.dart';

class ItemImage extends Equatable {
  final String? id;
  final String? url;

  const ItemImage({this.id, this.url});

  factory ItemImage.fromJson(Map<String, dynamic> data) {
    return ItemImage(
      id: data['id'] as String?,
      url: data['url'] as String?,
    );
  }

  ItemImage copyWith({
    String? id,
    String? url,
  }) {
    return ItemImage(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [id, url];
}
