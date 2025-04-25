import 'package:cloud_firestore/cloud_firestore.dart';
import 'venue_model.dart';

class BookingModel {
  final String id;
  final int maxUsers;
  final DateTime startTime;
  final DateTime endTime;
  final VenueModel venue;
  final List<String> users;

  BookingModel({
    required this.id,
    required this.maxUsers,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.users,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final venueJson = json['venue'];
    final coords = venueJson?['coords'];
    return BookingModel(
      id: json['id'] ?? '',
      maxUsers: json['max_users'] ?? 0,
      startTime: json['start_time'] is Timestamp
          ? (json['start_time'] as Timestamp).toDate()
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] is Timestamp
          ? (json['end_time'] as Timestamp).toDate()
          : DateTime.parse(json['end_time'] as String),
      venue: VenueModel.fromJson(json['venue'] ??
          {
            'id': '',
            'name': '',
            'location_name': '',
            'rating': 0.0,
            'image': '',
            'coords': coords is GeoPoint
                ? coords
                : GeoPoint(
                    (coords?['latitude'] ?? 0.0) as double,
                    (coords?['longitude'] ?? 0.0) as double,
                  ),
            'sport': {
              'id': '',
              'name': '',
              'logo': '',
            },
            'bookings': [],
          }),
      users:
          (json['users'] as List? ?? []).map((user) => user as String).toList(),
    );
  }

  factory BookingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return BookingModel(
      id: snapshot.id,
      maxUsers: snapshot['max_users'] ?? 0,
      startTime: (snapshot['start_time'] as Timestamp).toDate(),
      endTime: (snapshot['end_time'] as Timestamp).toDate(),
      venue: VenueModel.fromJson(snapshot['venue']),
      users: (snapshot['users'] as List? ?? [])
          .map((user) => user as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'max_users': maxUsers,
      'start_time': Timestamp.fromDate(startTime),
      'end_time': Timestamp.fromDate(endTime),
      'venue': venue.toJson(),
      'users': users,
    };
  }

  Map<String, dynamic> toJsonSerializable() {
    return {
      'id': id,
      'max_users': maxUsers,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'venue': venue.toJsonSerializable(),
      'users': users,
    };
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }
}
