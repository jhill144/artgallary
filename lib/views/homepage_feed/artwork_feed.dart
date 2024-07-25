import 'package:artgallery/utilities/firebase/firebase_data_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArtworkFeed extends StatefulWidget {
  const ArtworkFeed({super.key});

  @override
  _ArtworkFeedState createState() => _ArtworkFeedState();
}

class _ArtworkFeedState extends State<ArtworkFeed> {
  final FirebaseDataServices dataServices = FirebaseDataServices();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
      child: buildArtworkFeed(),
    ));
  }

  Widget buildArtworkFeed() {
    return StreamBuilder<QuerySnapshot>(
        stream: dataServices.getAllArtwork(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error fetching artworks: ${snapshot.error}');
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No artworks found'));
          }

          List<DocumentSnapshot> artworks = snapshot.data!.docs;

          return ListView.builder(
              itemCount: artworks.length,
              itemBuilder: (context, index) {
                var artworkData =
                    artworks[index].data() as Map<String, dynamic>;
                var artworkId = artworks[index].id;
                var artistusername = artworkData['artistUsername'];
                var imageUrl = artworkData['imageUrl'] ?? '';
                var title = artworkData['artworkName'] ?? 'No title';
                var description =
                    artworkData['artworkDescription'] ?? 'No description';

                return ArtworkCard(
                    artworkId: artworkId,
                    artist: artistusername,
                    artworkTitle: title,
                    artworkDescription: description,
                    artwork: imageUrl);
              });
        });
  }
}

class ArtworkCard extends StatelessWidget {
  const ArtworkCard({
    super.key,
    required this.artworkId,
    required this.artist,
    required this.artworkTitle,
    required this.artworkDescription,
    required this.artwork,
  });
  final String artworkId;
  final String artist;
  final String artworkTitle;
  final String artworkDescription;
  final String artwork;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 13 / 9,
        child: Column(children: [
          Card(
              color: Colors.blueAccent,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: <Widget>[
                  ArtistDetails(
                    username: artist,
                  ),
                  ArtworkImage(
                    artUrl: artwork,
                  ),
                  ArtworkDetails(
                    title: artworkTitle,
                    description: artworkDescription,
                  ),
                  const ArtworkReactions(),
                ]),
              )),
          const Divider(
            height: 5,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.black,
          ),
        ]));
  }
}

class ArtistDetails extends StatelessWidget {
  const ArtistDetails({
    super.key,
    required this.username,
  });
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.person_2),
        Text(username),
      ],
    );
  }
}

class ArtworkDetails extends StatelessWidget {
  const ArtworkDetails({
    super.key,
    required this.title,
    required this.description,
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        Text(description),
      ],
    );
  }
}

class ArtworkImage extends StatelessWidget {
  const ArtworkImage({
    super.key,
    required this.artUrl,
  });
  final String artUrl;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: artUrl.isNotEmpty
          ? Image.network(
              artUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image),
            )
          : const Icon(Icons.image),
    );
  }
}

class ArtworkReactions extends StatelessWidget {
  const ArtworkReactions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      Icon(Icons.heart_broken),
      Icon(Icons.mode_comment_outlined),
      Icon(Icons.share),
    ]);
  }
}
