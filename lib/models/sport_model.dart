class SportModel {
  final String id;
  final String name;
  final String logo;

  SportModel({required this.id, required this.name, required this.logo});

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }
}
