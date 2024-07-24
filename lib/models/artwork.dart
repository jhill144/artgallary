import 'package:artgallery/utilities/enums.dart';
import 'dart:core';

class Artwork {
  String artworkID;
  String artistUsername;
  String artistID;
  String artworkName;
  String artworkDescription;
  String imageUrl;
  DateTime? artworkCreate;
  DateTime? artworkUpdate;
  ArtworkAccess artworkAccess;

  Artwork({
    required this.artworkID,
    required this.artistID,
    required this.artistUsername,
    required this.artworkName,
    required this.artworkDescription,
    required this.artworkCreate,
    required this.imageUrl,
    this.artworkUpdate,
    this.artworkAccess = ArtworkAccess.artworkpublic,
  });

  Map<String, dynamic> toMap() {
    return {
      'artworkID': artworkID,
      'artistID': artistID,
      'artistUsername': artistUsername,
      'title': artworkName,
      'description': artworkDescription,
      'imageUrl': imageUrl,
      'dateCreated': artworkCreate,
      'artworkUpdate': artworkUpdate,
      'artworkAccess': artworkAccess.toString(),
    };
  }
}
