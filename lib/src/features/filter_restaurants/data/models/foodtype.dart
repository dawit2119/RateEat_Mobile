class University {
  final String name;
  final String alphaTwoCode;
  final List<String> domains;
  final String country;
  final List<String> webPages;
  final String stateProvince;

  University({
    required this.name,
    required this.alphaTwoCode,
    required this.domains,
    required this.country,
    required this.webPages,
    required this.stateProvince,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] ?? '',
      alphaTwoCode: json['alpha_two_code'] ?? '',
      domains: List<String>.from(json['domains'] ?? []),
      country: json['country'] ?? '',
      webPages: List<String>.from(json['web_pages'] ?? []),
      stateProvince: json['state-province'] ?? '',
    );
  }
}
