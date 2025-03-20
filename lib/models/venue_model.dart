import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_model.dart';
import 'sport_model.dart';

class VenueModel {
  final String id;
  final String name;
  final String locationName;
  final double rating;
  final String image;
  final GeoPoint coords;
  final SportModel sport;
  final List<BookingModel> bookings;

  VenueModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.rating,
    required this.image,
    required this.coords,
    required this.sport,
    required this.bookings,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      locationName: json['location_name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      coords: json['coords'] ?? const GeoPoint(0, 0),
      sport: SportModel.fromJson(json['sport']),
      bookings: (json['bookings'] as List? ?? [])
          .map((booking) =>
              BookingModel.fromJson(booking as Map<String, dynamic>))
          .toList(),
    );
  }

  factory VenueModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    return VenueModel(
      id: snapshot.id,
      name: snapshot['name'] ?? '',
      locationName: snapshot['location_name'] ?? '',
      rating: (snapshot['rating'] ?? 0.0).toDouble(),
      image: snapshot['image'] ?? '',
      coords: snapshot['coords'] ?? const GeoPoint(0, 0),
      sport: SportModel.fromJson(snapshot['sport']),
      bookings: (snapshot['bookings'] as List? ?? [])
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
      'coords': coords,
      'sport': sport.toJson(),
      'bookings': bookings.map((b) => b.toJson()).toList(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }
}

