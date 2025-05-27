import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isis3510_team32_flutter/view_models/connectivity/connectivity_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> timeInteractionStats(ConnectivityState state) async {
    debugPrint('✍🏻 Recording time interaction stats');

    final DateTime currentDate = DateTime.now();
    final int hour = currentDate.hour; // 0 to 23
    final int weekday = currentDate.weekday % 7; // 0 to 6 (Sunday = 0)
    final String dayName = dayNames[weekday];
    final String fieldPath = '$dayName.hour_$hour';

    if (state is ConnectivityOfflineState) {
      await _queueUpdate(fieldPath);
      debugPrint('❌ No internet. Queued update for $fieldPath');
      return;
    }

    await _sendUpdate(fieldPath);
    await _processQueue();
  }

  Future<void> _sendUpdate(String fieldPath) async {
    try {
      final docRef = _firestore.collection('analytics').doc('time_interaction');
      await docRef.update({
        fieldPath: FieldValue.increment(1),
      });
      debugPrint('✅ Successfully updated interaction time for $fieldPath');
    } catch (error) {
      await _queueUpdate(fieldPath);
      debugPrint('❗️ Error updating interaction time: $error');
    }
  }

  Future<void> _queueUpdate(String fieldPath) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> queue =
        prefs.getStringList('interaction_time_queue') ?? [];
    queue.add(fieldPath);
    await prefs.setStringList('interaction_time_queue', queue);
    debugPrint('✅ Queued update for $fieldPath');
  }

  Future<void> _processQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> queue =
        prefs.getStringList('interaction_time_queue') ?? [];

    if (queue.isEmpty) return;

    final procesedQueue = <String>[];

    try {
      final DocumentReference docRef =
          _firestore.collection('analytics').doc('time_interaction');

      for (final fieldPath in queue) {
        await docRef.update({
          fieldPath: FieldValue.increment(1),
        });
        procesedQueue.add(fieldPath);
        debugPrint('✅ Successfully processed queued update for $fieldPath');
      }
    } catch (error) {
      debugPrint('❗️ Error processing interaction time queue: $error');
      final List<String> newQueue =
          queue.where((item) => !procesedQueue.contains(item)).toList();
      await prefs.setStringList('interaction_time_queue', newQueue);
    }
  }
}
