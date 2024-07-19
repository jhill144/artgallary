import 'package:artgallery/utilities/enums.dart';
import 'dart:core';

class ArtworkGallery {
  final String artworkGalleryID;
  String artworkGalleryName;
  String artistID;
  DateTime? artworkGalleryCreate;
  DateTime? artworkGalleryUpdate;
  List<String>? artworkGallery;
  AccessLevel artworkAccess;

  ArtworkGallery({
    this.artworkGalleryID = '',
    this.artworkGalleryName = '',
    this.artistID = '',
    this.artworkGalleryCreate,
    this.artworkGalleryUpdate,
    this.artworkGallery,
    this.artworkAccess = AccessLevel.artpublic,
  });
}
