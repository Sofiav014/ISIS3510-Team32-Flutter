import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:isis3510_team32_flutter/models/data_models/booking_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/sport_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/user_model.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';

abstract class AuthEvent {}

class AuthInsertModelEvent extends AuthEvent {
  final UserModel userModel;

  AuthInsertModelEvent(this.userModel);
}

class AuthUpdateModelEvent extends AuthEvent {
  final String? id;
  final String? name;
  final DateTime? birthDate;
  final String? gender;
  final String? imageUrl;
  final List<SportModel>? sportsLiked;
  final List<VenueModel>? venuesLiked;
  final List<BookingModel>? bookings;

  AuthUpdateModelEvent(
      {this.id,
      this.name,
      this.birthDate,
      this.gender,
      this.imageUrl,
      this.sportsLiked,
      this.venuesLiked,
      this.bookings});
}

class AuthChangeLocalModelEvent extends AuthEvent {
  final User? user;
  final UserModel? userModel;
  AuthChangeLocalModelEvent(this.user, this.userModel);
}

class AuthRefreshModelEvent extends AuthEvent {}

class AuthUpdateImageEvent extends AuthEvent {
  final File file;
  AuthUpdateImageEvent(this.file);
}

class AuthLogOutEvent extends AuthEvent {}
