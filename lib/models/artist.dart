import 'package:artgallery/utilities/enums.dart';

class Artist {
  String artistID;
  String artistEmail;
  String artistUsername;
  AccessLevel artistAccess;

  Artist({
    this.artistID = '',
    this.artistEmail = '',
    this.artistUsername = '',
    this.artistAccess = AccessLevel.artpublic,
  });
}
