import 'package:artgallery/utilities/firebase/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuthServices _authServices = FirebaseAuthServices();
  final String defaultPfpUrl =
      'https://www.pngkey.com/png/detail/115-1150152_default-profile-picture-avatar-png-green.png';

  Future<void> createArtistDocument(String uid, String email) async {
    DocumentReference artistDoc = _fireStore.collection('artists').doc(uid);
    DocumentSnapshot artistSnapshot = await artistDoc.get();
    String username = email.split('@')[0];
    if (!artistSnapshot.exists) {
      await artistDoc.set({
        'artistID': uid,
        'artistEmail': email,
        'artistUsername': username,
        'artistPfpUrl': defaultPfpUrl,
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

  Future<Map<String, dynamic>?> getCurrentArtist() {
    return getSpecificArtist(_authServices.getCurrentUser() as String?);
  }

  Future<Map<String, dynamic>?> getSpecificArtist(String? uid) async {
    DocumentSnapshot artistSnapshot =
        await FirebaseFirestore.instance.collection('artists').doc(uid).get();
    return artistSnapshot.data() as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>?> getAllArtwork() async {
    DocumentSnapshot artWorkSnapshot =
        await FirebaseFirestore.instance.collection('artworks').doc().get();
    return artWorkSnapshot.data() as Map<String, dynamic>?;
  }

  Future<String> addArtistArtwork(
      String title, String description, String downloadUrl) async {
    Map<String, dynamic>? artistData =
        getCurrentArtist() as Map<String, dynamic>?;
    String artistUsername = artistData?['artistUsername'] ?? '';

    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('artworks').add({
      'artworkID': '',
      'artistID': _authServices.getCurrentUser(),
      'artistUsername': artistUsername,
      'artworkName': title,
      'artworkDescription': description,
      'imageUrl': downloadUrl,
      'artworkCreate': DateTime.now(),
    });

    String artworkId = docRef.id;
    await docRef.update({'artworkID': artworkId});

    await addArtworkToArtist(
        _authServices.getCurrentUser() as String, artworkId);

    print("Artwork ID: $artworkId");
    return artworkId;
  }

  Future<void> addArtworkToArtist(String artistId, String artworkId) async {
    try {
      await FirebaseFirestore.instance
          .collection('artists')
          .doc(artistId)
          .update({
        'artworkIds': FieldValue.arrayUnion([artworkId]),
      });
    } catch (e) {
      print('Error adding artwork to artist: $e');
    }
  }
}
