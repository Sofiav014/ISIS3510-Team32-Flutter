import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_model.dart';
import 'sport_model.dart';

class VenueModel {
  final String id;
  final String name;
  final String locationName;
  final double rating;
  final String image;
  final GeoPoint cords;
  final SportModel sport;
  final List<BookingModel>? bookings;

  VenueModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.rating,
    required this.image,
    required this.cords,
    required this.sport,
    this.bookings,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      locationName: json['location_name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      cords: json['cords'] ?? const GeoPoint(0, 0),
      sport: json['sport'] != null
          ? SportModel.fromJson(json['sport'] as Map<String, dynamic>)
          : SportModel(
              id: '', name: '', logo: ''), // Provide a default SportModel
      bookings: (json['bookings'] as List? ?? [])
          .map((booking) =>
              BookingModel.fromJson(booking as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location_name': locationName,
      'rating': rating,
      'image': image,
      'cords': cords,
      'sport': sport.toJson(),
      'bookings': bookings?.map((b) => b.toJson()).toList(),
    };
  }
}
