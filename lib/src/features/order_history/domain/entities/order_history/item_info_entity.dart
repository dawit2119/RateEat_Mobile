import 'dart:convert';

import 'package:equatable/equatable.dart';

class ItemInfoEntity extends Equatable {
  final String? name;
  final int? price;
  final String? imageUrl;

  const ItemInfoEntity({this.name, this.imageUrl, this.price});

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'image_url': imageUrl,
      };

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [name, price, imageUrl];
}
