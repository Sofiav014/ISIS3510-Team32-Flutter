import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isis3510_team32_flutter/models/user_model.dart';

class AuthRepository {
  static const String userCollection = "users";

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserModel?> fetchUser(String uid) async {
    final userModelRef = _db.collection(userCollection).doc(uid).withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel uM, _) => uM.toFirestore(),
        );
    return (await userModelRef.get()).data();
  }

  Future<void> uploadUser(UserModel userModel) async {
    final userModelRef =
        _db.collection(userCollection).doc(userModel.id).withConverter(
              fromFirestore: UserModel.fromFirestore,
              toFirestore: (UserModel uM, _) => uM.toFirestore(),
            );
    await userModelRef.set(userModel);
  }
}
