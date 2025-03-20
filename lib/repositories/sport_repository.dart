import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sport.dart';

class SportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Sport>> getSports() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('sports').get();

      return querySnapshot.docs.map((doc) {
        return Sport.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching sports: $e');
      return []; // Handle errors appropriately
    }
  }
}