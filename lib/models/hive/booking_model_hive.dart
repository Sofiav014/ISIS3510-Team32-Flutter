import 'package:hive_flutter/hive_flutter.dart';
import 'package:isis3510_team32_flutter/models/booking_model.dart';
import 'venue_model_hive.dart';

part 'booking_model_hive.g.dart';

@HiveType(typeId: 0)
class BookingModelHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int maxUsers;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime endTime;

  @HiveField(4)
  VenueModelHive venue;

  @HiveField(5)
  List<String> users;

  BookingModelHive({
    required this.id,
    required this.maxUsers,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.users,
  });

  factory BookingModelHive.fromModel(BookingModel model) => BookingModelHive(
        id: model.id,
        maxUsers: model.maxUsers,
        startTime: model.startTime,
        endTime: model.endTime,
        venue: VenueModelHive.fromModel(model.venue),
        users: model.users,
      );

  BookingModel toModel() => BookingModel(
        id: id,
        maxUsers: maxUsers,
        startTime: startTime,
        endTime: endTime,
        venue: venue.toModel(),
        users: users,
      );
}
