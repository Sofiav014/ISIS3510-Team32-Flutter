// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingModelHiveAdapter extends TypeAdapter<BookingModelHive> {
  @override
  final int typeId = 0;

  @override
  BookingModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingModelHive(
      id: fields[0] as String,
      maxUsers: fields[1] as int,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      venue: fields[4] as VenueModelHive,
      users: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookingModelHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.maxUsers)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.venue)
      ..writeByte(5)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
