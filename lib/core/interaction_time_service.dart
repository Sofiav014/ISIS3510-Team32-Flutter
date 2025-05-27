import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class InteractionTimeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void timeInteractionStats() {
    debugPrint('✍🏻 Recording time interaction stats');

    final DateTime currentDate = DateTime.now();
    final int hour = currentDate.hour; // 0 to 23
    final int weekday = (currentDate.weekday % 7); // 0 to 6 (0 = Sunday)

    // Reference to the "time_interaction" document in the "analytics" collection
    final DocumentReference statsRef =
        _firestore.collection('analytics').doc('time_interaction');

    // Field path representing the counter for the current hour and weekday
    final String fieldPath = 'day_$weekday.hour_$hour';

    // Increment the counter for the current hour and weekday
    statsRef.update({
      fieldPath: FieldValue.increment(1),
    }).then((_) {
      debugPrint('✅ Successfully updated time interaction stats');
    }).catchError((error) {
      debugPrint('❗️ Error updating time interaction stats: $error');
    });
  }
}
