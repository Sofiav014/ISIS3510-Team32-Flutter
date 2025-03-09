import 'package:cloud_firestore/cloud_firestore.dart';

class SportModel {
  final String id;
  final String name;
  final String logo;

  SportModel({required this.id, required this.name, required this.logo});

  static Future<SportModel> fromDocumentSnapshot(DocumentSnapshot doc) async {
    return SportModel(
      id: doc.id,
      name: doc['name'] ?? '',
      logo: doc['logo'] ?? '',
    );
  }
}
