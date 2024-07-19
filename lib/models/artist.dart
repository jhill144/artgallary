import 'package:artgallery/utilities/enums.dart';

class Artist {
  String artistID;
  String artistEmail;
  String artistUsername;
  ArtistAccess artistAccess;

  Artist({
    this.artistID = '',
    this.artistEmail = '',
    this.artistUsername = '',
    this.artistAccess = ArtistAccess.artpublic,
  });
}
