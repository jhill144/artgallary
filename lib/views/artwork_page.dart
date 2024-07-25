import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:artgallery/views/profile_page.dart';

class ArtworkPage extends StatelessWidget {
  final String artworkId;

  const ArtworkPage({super.key, required this.artworkId});

  @override
  Widget build(BuildContext context) {
    if (artworkId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Artwork Details'),
        ),
        body: const Center(child: Text('Invalid artwork ID')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('artworks')
            .doc(artworkId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Artwork not found'));
          }

          var artworkData = snapshot.data?.data() as Map<String, dynamic>?;
          if (artworkData == null) {
            return const Center(
                child: Text('No data available for this artwork'));
          }

          var title = artworkData['artworkName'] ?? 'No title';
          var description =
              artworkData['artworkDescription'] ?? 'No description';
          var imageUrl = artworkData['imageUrl'] ?? '';
          var artistId = artworkData['artistID'] ?? 'Unknown artist';
          var dateCreated =
              (artworkData['artworkCreate'] as Timestamp?)?.toDate() ??
                  DateTime.now();

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('artists')
                .doc(artistId)
                .get(),
            builder: (context, artistSnapshot) {
              if (artistSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (artistSnapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (!artistSnapshot.hasData || !artistSnapshot.data!.exists) {
                return const Center(child: Text('Artist not found'));
              }

              var artistData =
                  artistSnapshot.data?.data() as Map<String, dynamic>?;
              var artistUsername =
                  artistData?['artistUsername'] ?? 'Unknown artist';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl.isNotEmpty)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Text('Could not load image');
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(userId: artistId),
                          ),
                        );
                      },
                      child: Text(
                        'by $artistUsername',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uploaded on ${dateCreated.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Comments',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CommentSection(artworkId: artworkId),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CommentSection extends StatelessWidget {
  final String artworkId;
  final TextEditingController _commentController = TextEditingController();
  final String defaultProfilePictureUrl =
      'https://www.pngkey.com/png/detail/115-1150152_default-profile-picture-avatar-png-green.png';

  CommentSection({super.key, required this.artworkId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('artworks')
              .doc(artworkId)
              .collection('comments')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No comments yet. Be the first to comment!');
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var commentData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                var comment = commentData['comment'] ?? '';
                var commenterId = commentData['commenterID'] ?? '';

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('artists')
                      .doc(commenterId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return ListTile(
                        title: const Text('Unknown user'),
                        subtitle: Text(comment),
                      );
                    }

                    var userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;
                    var username =
                        userData?['artistUsername'] ?? 'Unknown user';
                    var profilePictureUrl = userData?['profilePictureUrl'] ??
                        defaultProfilePictureUrl;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profilePictureUrl),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(userId: commenterId),
                            ),
                          );
                        },
                        child: Text(
                          username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                      subtitle: Text(comment),
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: 'Add a comment',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (_commentController.text.isNotEmpty) {
              String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
              if (currentUserId != null) {
                await FirebaseFirestore.instance
                    .collection('artworks')
                    .doc(artworkId)
                    .collection('comments')
                    .add({
                  'comment': _commentController.text,
                  'commenterID': currentUserId,
                  'timestamp': Timestamp.now(),
                });
                _commentController.clear();
              }
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
