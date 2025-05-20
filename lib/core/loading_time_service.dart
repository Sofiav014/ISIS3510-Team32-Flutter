import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LoadingTimeService with ChangeNotifier {
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

    final collectionRef = _firestore
        .collection('analytics')
        .doc('loading_time')
        .collection('all');
    final docRef = collectionRef.doc(screenName);
    debugPrint(
        '✍🏻 Recording loading time for $screenName: $timeSpent seconds');
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
        debugPrint('✅ Successfully updated average loading time in Firestore');
      } else {
        await docRef.set({
          'average_time': timeSpent,
          'visit_count': 1,
        }, SetOptions(merge: true));
        debugPrint('✅ Successfully set average loading time in Firestore');
      }
    } catch (error) {
      debugPrint('❗️ Error updating document: $error');
    }

    _startTime = null;
  }

  Future<void> recordThemeSelection(String theme, bool isFirstTime) async {
    final docRef = _firestore.collection('analytics').doc('theme_selection');

    try {
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // Initialize both counts
        await docRef.set({
          'light': theme == 'light' ? 1 : 0,
          'dark': theme == 'dark' ? 1 : 0,
        });
        debugPrint('✅ Initialized theme selection counts');
        return;
      }

      final currentData = docSnapshot.data()!;
      final int lightCount = (currentData['light'] ?? 0) as int;
      final int darkCount = (currentData['dark'] ?? 0) as int;

      Map<String, int> updates = {};

      if (theme == 'light') {
        updates['light'] = lightCount + 1;
        if (!isFirstTime) {
          updates['dark'] = (darkCount > 0) ? darkCount - 1 : 0;
        }
      } else if (theme == 'dark') {
        updates['dark'] = darkCount + 1;
        if (!isFirstTime) {
          updates['light'] = (lightCount > 0) ? lightCount - 1 : 0;
        }
      }

      await docRef.update(updates);
      debugPrint('✅ Updated theme selection counts: $updates');
    } catch (error) {
      debugPrint('❗️ Error updating theme selection: $error');
    }
  }
}
