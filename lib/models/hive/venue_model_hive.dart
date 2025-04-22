import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';
import 'sport_model_hive.dart';

part 'venue_model_hive.g.dart';

@HiveType(typeId: 1)
class VenueModelHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String locationName;

  @HiveField(3)
  double rating;

  @HiveField(4)
  String image;

  @HiveField(5)
  double latitude;

  @HiveField(6)
  double longitude;

  @HiveField(7)
  SportModelHive sport;

  VenueModelHive({
    required this.id,
    required this.name,
    required this.locationName,
    required this.rating,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.sport,
  });

  factory VenueModelHive.fromModel(VenueModel model) => VenueModelHive(
        id: model.id,
        name: model.name,
        locationName: model.locationName,
        rating: model.rating,
        image: model.image,
        latitude: model.coords.latitude,
        longitude: model.coords.longitude,
        sport: SportModelHive.fromModel(model.sport),
      );

  VenueModel toModel() => VenueModel(
        id: id,
        name: name,
        locationName: locationName,
        rating: rating,
        image: image,
        coords: GeoPoint(latitude, longitude),
        sport: sport.toModel(),
        bookings: [],
      );
}
