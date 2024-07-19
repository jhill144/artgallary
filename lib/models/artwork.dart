import 'package:artgallery/utilities/enums.dart';
import 'dart:core';

class Artwork {
  String artworkID;
  String artistID;
  String artworkName;
  DateTime? artworkCreate;
  DateTime? artworkUpdate;
  ArtworkAccess artworkAccess;

  Artwork({
    this.artworkID = '',
    this.artistID = '',
    this.artworkName = '',
    this.artworkCreate,
    this.artworkUpdate,
    this.artworkAccess = ArtworkAccess.artworkpublic,
  });
}
