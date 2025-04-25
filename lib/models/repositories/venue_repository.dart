import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';

class VenueRepository {
  VenueRepository._internal();

  static final VenueRepository _instance = VenueRepository._internal();

  factory VenueRepository() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, VenueModel> _venueCache = {};

  Future<List<VenueModel>> getVenuesBySportId(String sportName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('venues')
          .where('sport.name', isEqualTo: sportName)
          .get();

      List<VenueModel> sportVenues =  querySnapshot.docs.map((doc) {
        Map<String, dynamic> venueData = doc.data() as Map<String, dynamic>;
        venueData['id'] = doc.id;
        return VenueModel.fromJson(venueData);
      }).toList();

      return sportVenues;
    } catch (e) {
      List<VenueModel> sportVenues = <VenueModel>[];

      for (String venueId in _venueCache.keys){
        VenueModel? venue = _venueCache[venueId];
        if (venue?.sport.name == sportName){
          sportVenues.add(venue!);
        }
      }
      return sportVenues;
    }
  }

  Future<VenueModel?> getVenueById(String venueId) async {
    try {
      if (!_venueCache.containsKey(venueId)){
        DocumentSnapshot documentSnapshot =
        await _firestore.collection('venues').doc(venueId).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> venueData = documentSnapshot.data() as Map<String, dynamic>;
          venueData['id'] = documentSnapshot.id;
          _venueCache[venueId] =  VenueModel.fromJson(venueData);
        } else {
          return null;
        }
      }
      return _venueCache[venueId];

    } catch (e) {
      print('Error fetching venue by ID: $e');
      return null;
    }
  }
}
