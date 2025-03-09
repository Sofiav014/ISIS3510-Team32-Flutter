import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';
import 'venue_model.dart';

class BookingModel {
  final String id;
  final int maxUsers;
  final DateTime startTime;
  final DateTime endTime;
  final List<UserModel> users;
  final VenueModel venue;

  BookingModel(
      {required this.id,
      required this.maxUsers,
      required this.startTime,
      required this.endTime,
      required this.users,
      required this.venue});

  static Future<BookingModel> fromDocumentSnapshot(DocumentSnapshot doc) async {
    try {
      List<UserModel> users = [];
      for (var userRef in doc['users']) {
        DocumentSnapshot userDoc = await userRef.get();
        if (userDoc.exists) {
          users.add(await UserModel.fromDocumentSnapshot(userDoc));
        } else {
          print('User document not found: ${userRef.id}');
        }
      }

      DocumentSnapshot venueDoc = await doc['venue'].get();
      if (venueDoc.exists) {
        VenueModel venue = await VenueModel.fromDocumentSnapshot(venueDoc);

        return BookingModel(
            id: doc.id,
            maxUsers: doc['max_users'],
            startTime: doc['start_time'].toDate(),
            endTime: doc['end_time'].toDate(),
            users: users,
            venue: venue);
      } else {
        print('Venue document not found: ${doc['venue'].id}');
        throw Exception("Venue document not found");
      }
    } catch (e) {
      print('Error loading BookingModel: $e');
      rethrow; // Re-throw the exception to be handled elsewhere
    }
  }
}
