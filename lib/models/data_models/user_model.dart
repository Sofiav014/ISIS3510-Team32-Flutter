import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_model.dart';
import 'sport_model.dart';
import 'venue_model.dart';

class UserModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String? imageUrl;
  final List<SportModel> sportsLiked;
  final List<VenueModel> venuesLiked;
  final List<BookingModel> bookings;

  UserModel({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.imageUrl,
    List<SportModel>? sportsLiked,
    List<VenueModel>? venuesLiked,
    List<BookingModel>? bookings,
  })  : sportsLiked = sportsLiked ?? [],
        venuesLiked = venuesLiked ?? [],
        bookings = bookings ?? [];

  UserModel copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? imageUrl,
    List<SportModel>? sportsLiked,
    List<VenueModel>? venuesLiked,
    List<BookingModel>? bookings,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
      sportsLiked: sportsLiked ?? this.sportsLiked,
      venuesLiked: venuesLiked ?? this.venuesLiked,
      bookings: bookings ?? this.bookings,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      birthDate: json['birth_date'] is Timestamp
          ? (json['birth_date'] as Timestamp).toDate()
          : json['birth_date'] is String
              ? DateTime.parse(json['birth_date'] as String)
              : DateTime.utc(0),
      gender: json['gender'] ?? '',
      imageUrl: json['image_url'],
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
      id: snapshot.id,
      name: snapshot['name'] ?? '',
      birthDate:
          (snapshot['birth_date'] as Timestamp?)?.toDate() ?? DateTime.utc(0),
      gender: snapshot['gender'] ?? '',
      imageUrl: snapshot.data()?["image_url"],
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
      'birth_date': birthDate,
      'gender': gender,
      if (imageUrl != null) 'image_url': imageUrl,
      'sports_liked': sportsLiked.map((sport) => sport.toJson()).toList(),
      'venues_liked': venuesLiked.map((venue) => venue.toJson()).toList(),
      'bookings': bookings.map((b) => b.toJson()).toList(),
    };
  }

  Map<String, dynamic> toJsonSerializable() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      if (imageUrl != null) 'image_url': imageUrl,
      'sports_liked': sportsLiked.map((sport) => sport.toJson()).toList(),
      'venues_liked':
          venuesLiked.map((venue) => venue.toJsonSerializable()).toList(),
      'bookings': bookings.map((b) => b.toJsonSerializable()).toList(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }

  @override
  String toString() {
    return "UserModel{${toJson()}}";
  }


  void addLikedVenue(VenueModel venue){
    bool notLiked = true;
    for(VenueModel likedVenue in venuesLiked){
      if (likedVenue.id == venue.id) notLiked = false;
    }

    final venueDoc = {
      'coords': venue.coords,
      'id': venue.id,
      'image': venue.image,
      'location_name': venue.locationName,
      'name': venue.name,
      'rating': venue.rating,
      'sport': venue.sport.toJson(),
    };

    if(notLiked) venuesLiked.add(VenueModel.fromJson(venueDoc));
  }

  void removeLikedVenue(VenueModel venue){
    int? removeIndex;
    for(int i = 0; i<venuesLiked.length; i++){
      if(venuesLiked[i].id == venue.id) removeIndex = i;
    }
    if(removeIndex != null) venuesLiked.removeAt(removeIndex);
  }

  bool containsLikedVenue(VenueModel venue){
    bool containsVenue = false;
    for (VenueModel likedVenue in venuesLiked){
      if(likedVenue.id == venue.id) containsVenue = true;
    }
    return containsVenue;
  }


}
