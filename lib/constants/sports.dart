import 'package:isis3510_team32_flutter/models/data_models/sport_model.dart';

Map<String, SportModel> initiationSports = {
  "basketball": SportModel(
      id: "basketball",
      name: "Basketball",
      logo:
          "https://firebasestorage.googleapis.com/v0/b/moviles-isis3510.firebasestorage.app/o/icons%2Fsports%2Fbasketball-logo-svg.svg?alt=media&token=3a5f39dc-8943-4386-b474-8209d29a1469"),
  "football": SportModel(
      id: "football",
      name: "Football",
      logo:
          "https://firebasestorage.googleapis.com/v0/b/moviles-isis3510.firebasestorage.app/o/icons%2Fsports%2Ffootball-logo-svg.svg?alt=media&token=788dbc8f-5a1d-4ba8-bc42-15f3ea3814f3"),
  "volleyball": SportModel(
      id: "volleyball",
      name: "Volleyball",
      logo:
          "https://firebasestorage.googleapis.com/v0/b/moviles-isis3510.firebasestorage.app/o/icons%2Fsports%2Fvolleyball-logo-svg.svg?alt=media&token=489aea30-514d-499f-8e64-03b23e917e21"),
  "tennis": SportModel(
      id: "tennis",
      name: "Tennis",
      logo:
          "https://firebasestorage.googleapis.com/v0/b/moviles-isis3510.firebasestorage.app/o/icons%2Fsports%2Ftennis-logo-svg.svg?alt=media&token=b9441062-25d4-4da5-9220-2e0c27c30792"),
};

Map<String, SportModel> sportLocal = {
  "basketball": SportModel(
      id: "basketball",
      name: "Basketball",
      logo: "assets/icons/initiation/basketball-logo.svg"),
  "football": SportModel(
      id: "football",
      name: "Football",
      logo: "assets/icons/initiation/football-logo.svg"),
  "volleyball": SportModel(
      id: "volleyball",
      name: "Volleyball",
      logo: "assets/icons/initiation/volleyball-logo.svg"),
  "tennis": SportModel(
      id: "tennis",
      name: "Tennis",
      logo: "assets/icons/initiation/tennis-logo.svg"),
};
