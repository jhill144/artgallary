import 'package:artgallery/utilities/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  String artistID;
  String artistEmail;
  String artistUsername;
  ArtistAccess artistAccess;
  List<String> artworkID;

  Artist({
    required this.artistID,
    required this.artistEmail,
    required this.artistUsername,
    this.artistAccess = ArtistAccess.artpublic,
    required this.artworkID,
  });

  Map<String, dynamic> toMap() {
    return {
      'artistID': artistID,
      'artistUsername': artistUsername,
      'artistEmail': artistEmail,
      'artworkID': artworkID,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      artistID: map['artistID'] ?? '',
      artistUsername: map['artistUsername'] ?? '',
      artistEmail: map['artistEmail'] ?? '',
      artworkID: List<String>.from(map['artworkID'] ?? []),
    );
  }

  DocumentReference get documentReference =>
      FirebaseFirestore.instance.collection('artists').doc(artistID);
}
