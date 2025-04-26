// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SportModelHiveAdapter extends TypeAdapter<SportModelHive> {
  @override
  final int typeId = 2;

  @override
  SportModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SportModelHive(
      id: fields[0] as String,
      name: fields[1] as String,
      logo: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SportModelHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.logo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
