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
    return BookingModel(
      id: json['id'] ?? '',
      maxUsers: json['max_users'] ?? 0,
      startTime: (json['start_time'] as Timestamp).toDate(),
      endTime: (json['end_time'] as Timestamp).toDate(),
      venue: VenueModel.fromJson(json['venue']),
      users: (json['users'] as List? ?? [])
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
}
