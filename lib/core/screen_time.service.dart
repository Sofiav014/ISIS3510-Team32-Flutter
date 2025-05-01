import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScreenTimeService with ChangeNotifier {
  DateTime? _startTime;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Start tracking time
  void startTrackingTime() {
    _startTime = DateTime.now();
  }

  // Stop tracking time and record it to Firebase
  Future<void> stopAndRecordTime(String screenName) async {
    if (_startTime == null) return;

    final timeSpent =
        DateTime.now().difference(_startTime!).inSeconds.toDouble();

    final collectionRef =
        _firestore.collection('analytics').doc('screen_time').collection('all');
    final docRef = collectionRef.doc(screenName);
    print('Recording screen time for $screenName: $timeSpent seconds');
    try {
      // Fetch the document to update average time
      final document = await docRef.get();
      if (document.exists) {
        final currentAvgTime = (document['average_time'] ?? 0.0);
        final visitCount = (document['visit_count'] ?? 0);

        final double safeCurrentAvgTime = (currentAvgTime is int)
            ? currentAvgTime.toDouble()
            : currentAvgTime as double;
        final int safeVisitCount = visitCount as int;

        final newAvgTime = ((safeCurrentAvgTime * safeVisitCount) + timeSpent) /
            (safeVisitCount + 1);

        await docRef.update({
          'average_time': newAvgTime,
          'visit_count': visitCount + 1,
        });
        print('Successfully updated average screen time in Firestore');
      } else {
        await docRef.set({
          'average_time': timeSpent,
          'visit_count': 1,
        }, SetOptions(merge: true));
        print('Successfully set average screen time in Firestore');
      }
    } catch (error) {
      print('Error updating document: $error');
    }

    _startTime = null;
  }
}
