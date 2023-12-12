import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ether_app/core/constants/constants.dart';
import 'package:ether_app/core/constants/firebase_constants.dart';
import 'package:ether_app/core/failure.dart';
import 'package:ether_app/core/providers/firebase_providers.dart';
import 'package:ether_app/core/type_defs.dart';
import 'package:ether_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';


final authRepositoryProvider = Provider(
  (ref) => AuthRepository(firestore: ref.read(firestoreProvider), auth: ref.read(authProvider), googleSignIn: ref.read(googleSignInProvider))
);


class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository( {required FirebaseFirestore firestore, required FirebaseAuth auth, required googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

    CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
    Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: []
        );

        // store user data to firestore
        _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } catch (error) {
        return left(Failure(error.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
