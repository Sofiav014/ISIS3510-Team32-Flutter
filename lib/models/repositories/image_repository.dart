import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepository {
  static const String imageBucket = "users";

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(String id, File imageFile) async {
    final storageRef = _storage.ref().child('$imageBucket/$id');

    // Upload the image
    await storageRef.putFile(imageFile);

    // Get the download URL
    final url = await storageRef.getDownloadURL();

    // Get image size in kilobytes
    final int imageSizeBytes = await imageFile.length();
    final double imageSizeKB = imageSizeBytes / 1024.0;

    // Reference to the global analytics document
    final analyticsRef = _firestore.collection('analytics').doc('uploads');

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(analyticsRef);

      double totalSize = 0;
      int uploadCount = 0;

      if (snapshot.exists) {
        final data = snapshot.data()!;
        totalSize = (data['totalSizeKB'] ?? 0).toDouble();
        uploadCount = (data['uploadCount'] ?? 0).toInt();
      }

      totalSize += imageSizeKB;
      uploadCount += 1;
      final averageSize = totalSize / uploadCount;

      transaction.set(
          analyticsRef,
          {
            'totalSizeKB': totalSize,
            'uploadCount': uploadCount,
            'averageUploadSizeKB': averageSize,
          },
          SetOptions(merge: true));
    });

    return url;
  }
}
