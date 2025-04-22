import 'package:hive_flutter/hive_flutter.dart';
import 'package:isis3510_team32_flutter/models/sport_model.dart';

part 'sport_model_hive.g.dart';

@HiveType(typeId: 2)
class SportModelHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String logo;

  SportModelHive({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory SportModelHive.fromModel(SportModel model) => SportModelHive(
        id: model.id,
        name: model.name,
        logo: model.logo,
      );

  SportModel toModel() => SportModel(
        id: id,
        name: name,
        logo: logo,
      );
}
