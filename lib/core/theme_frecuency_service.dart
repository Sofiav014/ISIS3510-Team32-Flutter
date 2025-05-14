import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ThemeFrecuencyService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> recordThemeChangeStatus(bool firstTime) async {
    final docRef =
        _firestore.collection('analytics').doc('theme_change_status');

    try {
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set({
          'userNotChangedTheme': firstTime ? 1 : 0,
          'userChangedTheme': firstTime ? 0 : 1,
        });
        debugPrint('✅ Initialized theme change status');
        return;
      }

      final data = docSnapshot.data()!;
      final int notChanged = (data['userNotChangedTheme'] ?? 0) as int;
      final int changed = (data['userChangedTheme'] ?? 0) as int;

      Map<String, int> updates = {};

      if (firstTime) {
        updates['userNotChangedTheme'] = notChanged + 1;
      } else {
        updates['userNotChangedTheme'] = (notChanged > 0) ? notChanged - 1 : 0;
        updates['userChangedTheme'] = changed + 1;
      }

      await docRef.update(updates);
      debugPrint('✅ Updated theme change status: $updates');
    } catch (error) {
      debugPrint('❗️ Error updating theme change status: $error');
    }
  }
}
