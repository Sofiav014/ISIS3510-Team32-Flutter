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
  final String? distance;

  VenueModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.rating,
    required this.image,
    required this.coords,
    required this.sport,
    required this.bookings,
    this.distance,
  });

  VenueModel copyWith({
    String? id,
    String? name,
    String? locationName,
    double? rating,
    String? image,
    GeoPoint? coords,
    SportModel? sport,
    List<BookingModel>? bookings,
    String? distance,
  }) {
    return VenueModel(
      id: id ?? this.id,
      name: name ?? this.name,
      locationName: locationName ?? this.locationName,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      coords: coords ?? this.coords,
      sport: sport ?? this.sport,
      bookings: bookings ?? this.bookings,
      distance: distance ?? this.distance,
    );
  }

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    final coords = json['coords'];
    return VenueModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      locationName: json['location_name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      coords: coords is GeoPoint
          ? coords // If it's already a GeoPoint, use it directly
          : GeoPoint(
              coords['latitude'] ?? 0.0,
              coords['longitude'] ?? 0.0,
            ), // Convert Map to GeoPoint,
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

  Map<String, dynamic> toJsonSerializable() {
    return {
      'id': id,
      'name': name,
      'location_name': locationName,
      'rating': rating,
      'image': image,
      'coords': {
        'latitude': coords.latitude,
        'longitude': coords.longitude,
      },
      'sport': sport.toJson(),
      'bookings': bookings.map((b) => b.toJsonSerializable()).toList(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }
}
