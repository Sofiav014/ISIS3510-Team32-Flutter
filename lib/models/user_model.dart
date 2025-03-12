import 'package:cloud_firestore/cloud_firestore.dart';

import 'booking_model.dart';
import 'sport_model.dart';
import 'venue_model.dart';

class UserModel {
  final String id;
  final String name;
  final int age;
  final String sex;
  final List<SportModel> sportsLiked;
  final List<VenueModel> venuesLiked;
  final List<BookingModel> bookings;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
    List<SportModel>? sportsLiked,
    List<VenueModel>? venuesLiked,
    List<BookingModel>? bookings,
  })  : sportsLiked = sportsLiked ?? [],
        venuesLiked = venuesLiked ?? [],
        bookings = bookings ?? [];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      sex: json['sex'] ?? '',
      sportsLiked: (json['sports_liked'] as List? ?? [])
          .map((sport) => SportModel.fromJson(sport))
          .toList(),
      venuesLiked: (json['venues_liked'] as List? ?? [])
          .map((venue) => VenueModel.fromJson(venue))
          .toList(),
      bookings: (json['bookings'] as List? ?? [])
          .map((booking) => BookingModel.fromJson(booking))
          .toList(),
    );
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return UserModel(
      id: snapshot['id'] ?? '',
      name: snapshot['name'] ?? '',
      age: snapshot['age'] ?? 0,
      sex: snapshot['sex'] ?? '',
      sportsLiked: (snapshot['sports_liked'] as List? ?? [])
          .map((sport) => SportModel.fromJson(sport))
          .toList(),
      venuesLiked: (snapshot['venues_liked'] as List? ?? [])
          .map((venue) => VenueModel.fromJson(venue))
          .toList(),
      bookings: (snapshot['bookings'] as List? ?? [])
          .map((booking) => BookingModel.fromJson(booking))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'sex': sex,
      'sports_liked': sportsLiked.map((sport) => sport.toJson()).toList(),
      'venues_liked': venuesLiked.map((venue) => venue.toJson()).toList(),
      'bookings': bookings.map((b) => b.toJson()).toList(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }

  @override
  String toString() {
    return "UserModel{${toJson()}}";
  }
}
