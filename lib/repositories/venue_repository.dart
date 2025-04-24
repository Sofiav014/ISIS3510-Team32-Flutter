import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/venue_model.dart';

class VenueRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<VenueModel>> getVenuesBySportId(String sportName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('venues')
          .where('sport.name', isEqualTo: sportName)
          .get();

      return querySnapshot.docs.map((doc) {
        return VenueModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching venues: $e');
      return []; // Handle errors appropriately
    }
  }

}
