import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class InteractionTimeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> dayNames = [
    'Sunday', // 0
    'Monday', // 1
    'Tuesday', // 2
    'Wednesday', // 3
    'Thursday', // 4
    'Friday', // 5
    'Saturday', // 6
  ];

  void timeInteractionStats() {
    debugPrint('✍🏻 Recording time interaction stats');

    final DateTime currentDate = DateTime.now();
    final int hour = currentDate.hour; // 0 to 23
    final int weekday = currentDate.weekday % 7; // 0 to 6 (Sunday = 0)

    final String dayName = dayNames[weekday];

    // Reference to the "time_interaction" document in the "analytics" collection
    final DocumentReference statsRef =
        _firestore.collection('analytics').doc('time_interaction');

    // Field path with day name and hour
    final String fieldPath = '$dayName.hour_$hour';

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
