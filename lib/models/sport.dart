class Sport {
  final String id;
  final String name;
  final String imageUrl;

  Sport({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Sport.fromJson(Map<String, dynamic> json, String id) {
    return Sport(
      id: id,
      name: json['name'],
      imageUrl: json['logo'],
    );
  }
}