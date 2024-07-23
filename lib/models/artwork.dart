import 'package:artgallery/utilities/enums.dart';
import 'dart:core';

class Artwork {
  String artworkID;
  String artistID;
  String artworkName;
  DateTime? artworkCreate;
  DateTime? artworkUpdate;
  AccessLevel artworkAccess;

  Artwork({
    this.artworkID = '',
    this.artistID = '',
    this.artworkName = '',
    this.artworkCreate,
    this.artworkUpdate,
    this.artworkAccess = AccessLevel.artpublic,
  });
}
