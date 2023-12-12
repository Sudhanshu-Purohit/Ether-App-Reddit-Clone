import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ether_app/core/constants/firebase_constants.dart';
import 'package:ether_app/core/failure.dart';
import 'package:ether_app/core/providers/firebase_providers.dart';
import 'package:ether_app/core/type_defs.dart';
import 'package:ether_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final UserProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(firestore: ref.watch(firestoreProvider))
);


class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({required FirebaseFirestore firestore}) : _firestore = firestore;
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}