import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory SportModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return SportModel(
      id: snapshot.id,
      name: snapshot['name'] ?? '',
      logo: snapshot['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }
}
