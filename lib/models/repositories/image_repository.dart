import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageRepository {
  static const String imageBuckeet = "users";

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(String id, File imageFile) async {
    final storageRef = _storage.ref().child('users/$id');

    String? url;

    await storageRef.putFile(imageFile);
    url = await storageRef.getDownloadURL();

    return url;
  }
}
