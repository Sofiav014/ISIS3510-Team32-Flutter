import 'package:cloud_firestore/cloud_firestore.dart';
import 'sport_model.dart';

class VenueModel {
  final String id;
  final String name;
  final String locationName;
  final double rating;
  final String image;
  final SportModel sport;
  final GeoPoint coords;

  VenueModel(
      {required this.id,
      required this.name,
      required this.locationName,
      required this.rating,
      required this.image,
      required this.sport,
      required this.coords});

  static Future<VenueModel> fromDocumentSnapshot(DocumentSnapshot doc) async {
    DocumentSnapshot sportDoc = await doc['sport'].get();
    if (sportDoc.exists) {
      SportModel sport = await SportModel.fromDocumentSnapshot(sportDoc);

      return VenueModel(
        id: doc.id,
        name: doc['name'] ?? '',
        locationName: doc['location_name'] ?? '',
        rating: doc['rating'] ?? 0.0,
        image: doc['image'] ?? '',
        sport: sport,
        coords: doc['coords'],
      );
    } else {
      throw Exception("Sport document does not exist");
    }
  }
}
