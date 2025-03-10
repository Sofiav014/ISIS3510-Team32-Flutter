import 'package:cloud_firestore/cloud_firestore.dart';
import 'sport_model.dart';
import 'venue_model.dart';

class UserModel {
  final String id;
  final String name;
  final int age;
  final String sex;
  final List<SportModel> sportsLiked;
  final List<VenueModel> venuesLiked;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.sportsLiked,
    required this.venuesLiked,
  });

  static Future<UserModel> fromDocumentSnapshot(DocumentSnapshot doc) async {
    try {
      List<SportModel> sportsLiked = [];
      List<VenueModel> venuesLiked = [];

      // Batch fetch sports
      List<DocumentReference> sportRefs =
          (doc['sports_liked'] as List?)?.cast<DocumentReference>() ?? [];
      List<Future<DocumentSnapshot>> sportFutures =
          sportRefs.map((ref) => ref.get()).toList();
      List<DocumentSnapshot> sportDocs = await Future.wait(sportFutures);
      for (var sportDoc in sportDocs) {
        if (sportDoc.exists) {
          sportsLiked.add(await SportModel.fromDocumentSnapshot(sportDoc));
        }
      }

      // Batch fetch venues
      List<DocumentReference> venueRefs =
          (doc['venues_liked'] as List?)?.cast<DocumentReference>() ?? [];
      List<Future<DocumentSnapshot>> venueFutures =
          venueRefs.map((ref) => ref.get()).toList();
      List<DocumentSnapshot> venueDocs = await Future.wait(venueFutures);
      for (var venueDoc in venueDocs) {
        if (venueDoc.exists) {
          venuesLiked.add(await VenueModel.fromDocumentSnapshot(venueDoc));
        }
      }

      return UserModel(
        id: doc.id,
        name: doc['name'] ?? '',
        age: doc['age'] ?? 0,
        sex: doc['sex'] ?? '',
        sportsLiked: sportsLiked,
        venuesLiked: venuesLiked,
      );
    } catch (e) {
      print('Error loading UserModel: $e');
      rethrow; // Re-throw to handle errors elsewhere
    }
  }
}
