class RestaurantResult {
  final String id;
  final String name;

  RestaurantResult({required this.id, required this.name});

  factory RestaurantResult.fromJson(Map<String, dynamic> json) {
    return RestaurantResult(
      id: json['id'],
      name: json['name'],
    );
  }
}
