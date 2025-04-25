import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/data_models/venue_model.dart';

class VenueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<VenueModel>> getVenuesBySportId(String sportName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('venues')
          .where('sport.name', isEqualTo: sportName)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> venueData = doc.data() as Map<String, dynamic>;
        venueData['id'] = doc.id;
        return VenueModel.fromJson(venueData);
      }).toList();
    } catch (e) {
      print('Error fetching venues: $e');
      return [];
    }
  }

  Future<VenueModel?> getVenueById(String venueId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('venues').doc(venueId).get();

      if (documentSnapshot.exists) {
        return VenueModel.fromJson(
            documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching venue by ID: $e');
      return null;
    }
  }
}
