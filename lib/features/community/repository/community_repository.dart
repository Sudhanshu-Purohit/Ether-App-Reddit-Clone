import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ether_app/core/constants/firebase_constants.dart';
import 'package:ether_app/core/failure.dart';
import 'package:ether_app/core/providers/firebase_providers.dart';
import 'package:ether_app/core/type_defs.dart';
import 'package:ether_app/models/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(firestore: ref.watch(firestoreProvider))
);

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore}) : _firestore = firestore;
  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if(communityDoc.exists) {
        throw "Community with the same name already exists!";
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update({'members': FieldValue.arrayUnion([userId])})
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update({'members': FieldValue.arrayRemove([userId])})
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for(var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities.where(
      'name',
      isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
      isLessThan: query.isEmpty ? null : query.substring(0, query.length - 1) + String.fromCharCode(
        query.codeUnitAt(query.length-1)+1,
      ),
    ).snapshots().map((event) {
        List<Community> communities = [];
        for(var community in event.docs) {
          communities.add(Community.fromMap(community.data() as Map<String, dynamic>));
        }
        return communities;
      });
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'mods': uids
        })
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}