class ItemTag {
  ItemTag({required this.id, required this.name});
  final String? id;
  final String? name;

  factory ItemTag.fromJson(Map<String, dynamic> data) {
    return ItemTag(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
    );
  }
}
