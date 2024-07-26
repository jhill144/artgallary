import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:artgallery/views/profile_page.dart';
import 'package:intl/intl.dart';

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
          var likes = List<String>.from(artworkData['likes'] ?? []);
          var shares = List<String>.from(artworkData['shares'] ?? []);

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
                      'Uploaded on ${DateFormat('MM-dd-yyyy').format(dateCreated)} at ${DateFormat('hh:mm a').format(dateCreated)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            likes.contains(
                                    FirebaseAuth.instance.currentUser?.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          onPressed: () async {
                            String? currentUserId =
                                FirebaseAuth.instance.currentUser?.uid;
                            if (currentUserId == null) return;

                            DocumentReference artworkRef = FirebaseFirestore
                                .instance
                                .collection('artworks')
                                .doc(artworkId);

                            if (likes.contains(currentUserId)) {
                              await artworkRef.update({
                                'likes': FieldValue.arrayRemove([currentUserId])
                              });
                            } else {
                              await artworkRef.update({
                                'likes': FieldValue.arrayUnion([currentUserId])
                              });
                            }
                          },
                        ),
                        Text('${likes.length} likes'),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            shares.contains(
                                    FirebaseAuth.instance.currentUser?.uid)
                                ? Icons.share
                                : Icons.share_outlined,
                          ),
                          onPressed: () async {
                            String? currentUserId =
                                FirebaseAuth.instance.currentUser?.uid;
                            if (currentUserId == null) return;

                            DocumentReference artworkRef = FirebaseFirestore
                                .instance
                                .collection('artworks')
                                .doc(artworkId);

                            if (shares.contains(currentUserId)) {
                              await artworkRef.update({
                                'shares':
                                    FieldValue.arrayRemove([currentUserId])
                              });
                            } else {
                              await artworkRef.update({
                                'shares': FieldValue.arrayUnion([currentUserId])
                              });
                            }
                          },
                        ),
                        Text('${shares.length} shares'),
                      ],
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

class CommentSection extends StatefulWidget {
  final String artworkId;

  const CommentSection({super.key, required this.artworkId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  final String defaultProfilePictureUrl =
      'https://www.pngkey.com/png/detail/115-1150152_default-profile-picture-avatar-png-green.png';

  Future<void> _toggleLikeComment(String commentId, List<dynamic> likes) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    DocumentReference commentRef = FirebaseFirestore.instance
        .collection('artworks')
        .doc(widget.artworkId)
        .collection('comments')
        .doc(commentId);

    if (likes.contains(currentUserId)) {
      await commentRef.update({
        'likes': FieldValue.arrayRemove([currentUserId])
      });
    } else {
      await commentRef.update({
        'likes': FieldValue.arrayUnion([currentUserId])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('artworks')
              .doc(widget.artworkId)
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var commentData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                var commentId = snapshot.data!.docs[index].id;
                var comment = commentData['comment'] ?? '';
                var commenterId = commentData['commenterID'] ?? '';
                var likes = commentData['likes'] ?? [];
                var timestamp =
                    (commentData['timestamp'] as Timestamp?)?.toDate() ??
                        DateTime.now();

                var formattedTimestamp =
                    DateFormat('MM-dd-yyyy hh:mm a').format(timestamp);

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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment),
                            const SizedBox(height: 5),
                            Text(
                              formattedTimestamp,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                likes.contains(
                                        FirebaseAuth.instance.currentUser?.uid)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () =>
                                  _toggleLikeComment(commentId, likes),
                            ),
                            Text(
                              '${likes.length} likes',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment),
                          const SizedBox(height: 5),
                          Text(
                            formattedTimestamp,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              likes.contains(
                                      FirebaseAuth.instance.currentUser?.uid)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            onPressed: () =>
                                _toggleLikeComment(commentId, likes),
                          ),
                          Text(
                            '${likes.length} likes',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
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
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () async {
              if (_commentController.text.isNotEmpty) {
                String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
                if (currentUserId != null) {
                  await FirebaseFirestore.instance
                      .collection('artworks')
                      .doc(widget.artworkId)
                      .collection('comments')
                      .add({
                    'comment': _commentController.text,
                    'commenterID': currentUserId,
                    'timestamp': Timestamp.now(),
                    'likes': [],
                  });
                  _commentController.clear();
                }
              }
            },
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}
