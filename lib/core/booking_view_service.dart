import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BookingViewService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stop tracking time and record it to Firebase
  Future<void> recordView(String screenName) async {
    final collectionRef = _firestore
        .collection('analytics')
        .doc('booking_view')
        .collection('all');
    final docRef = collectionRef.doc(screenName);
    debugPrint('✍🏻 Recording booking view for $screenName');
    try {
      // Fetch the document to update average time
      final document = await docRef.get();
      if (document.exists) {
        final bookingCount = (document['count'] ?? 0);

        await docRef.update({
          'count': bookingCount + 1,
        });
        debugPrint('✅ Successfully updated booking view count in Firestore');
      } else {
        await docRef.set({
          'count': 1,
        }, SetOptions(merge: true));
        debugPrint('✅ Successfully set booking view count in Firestore');
      }
    } catch (error) {
      debugPrint('❗️ Error updating document: $error');
    }
  }
}
