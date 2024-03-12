import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  final String? id;

  const Menu({this.id});

  factory Menu.fromJson(Map<String, dynamic> data) => Menu(
        id: data['id'] as String?,
      );

  Menu copyWith({
    String? id,
  }) {
    return Menu(
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [id];
}
