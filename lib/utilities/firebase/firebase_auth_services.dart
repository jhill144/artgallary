import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        await createArtistDocument(credential.user!.uid, email);
      }
      return user;
    } catch (e) {
      print('Error occurred creating user. - ${e.toString()}');
    }

    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email.trim().toLowerCase(), password: password);
      User? user = credential.user;
      if (user != null) {
        await createArtistDocument(user.uid, email);
      }
      return user;
    } catch (e) {
      print('Error occurred signing in user. - ${e.toString()}');
    }

    return null;
  }

  Future<User?> getCurrentUserId() async {
    User? user = _auth.currentUser;
    return user;
  }

  Future<String?> getUsername(String? uid) async {
    if (uid == null) return null;
    DocumentSnapshot artistDoc =
        await FirebaseFirestore.instance.collection('artists').doc(uid).get();
    if (artistDoc.exists) {
      Map<String, dynamic>? artistData =
          artistDoc.data() as Map<String, dynamic>?;
      return artistData?['artistUsername'];
    }
    return null;
  }

  Future<void> createArtistDocument(String uid, String email) async {
    DocumentReference artistDoc =
        FirebaseFirestore.instance.collection('artists').doc(uid);
    DocumentSnapshot artistSnapshot = await artistDoc.get();
    String username = email.split('@')[0];
    if (!artistSnapshot.exists) {
      await artistDoc.set({
        'artistID': uid,
        'artistEmail': email,
        'artistUsername': username,
        'artworkIds': [],
      });
    } else {
      Map<String, dynamic>? artistData =
          artistSnapshot.data() as Map<String, dynamic>?;
      if (artistData != null && artistData['artistUsername'] == '') {
        await artistDoc.update({
          'artistUsername': username,
        });
      }
    }
  }
}
