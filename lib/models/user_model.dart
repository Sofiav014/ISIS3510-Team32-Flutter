import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_model.dart';
import 'sport_model.dart';
import 'venue_model.dart';

class UserModel {
  final String id;
  final String name;
  final DateTime birth_date;
  final String gender;
  final List<SportModel> sportsLiked;
  final List<VenueModel> venuesLiked;
  final List<BookingModel> bookings;

  UserModel({
    required this.id,
    required this.name,
    required this.birth_date,
    required this.gender,
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
      birth_date: (json['birth_date'] as Timestamp).toDate(),
      gender: json['gender'] ?? '',
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birth_date': birth_date,
      'gender': gender,
      'sports_liked': sportsLiked.map((sport) => sport.toJson()).toList(),
      'venues_liked': venuesLiked.map((venue) => venue.toJson()).toList(),
      'bookings': bookings.map((b) => b.toJson()).toList(),
    };
  }
}
