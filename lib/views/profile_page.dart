import 'package:artgallery/utilities/directoryrouter.dart';
import 'package:artgallery/utilities/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:artgallery/views/artwork_page.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String bio = "Artist and photographer.";
  String profilePictureUrl = "assets/profile_picture.jpg";
  String name = "Your Name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildTabSection(),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 1),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(profilePictureUrl),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            bio,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final result = await context.pushNamed(
                DirectoryRouter.editprofilepage,
                extra: {
                  'currentName': name,
                  'currentBio': bio,
                  'currentProfilePictureUrl': profilePictureUrl,
                },
              );

              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  name = result['name'] as String;
                  bio = result['bio'] as String;
                  profilePictureUrl = result['profilePictureUrl'] as String;
                });
              }
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Uploaded Art'),
              Tab(text: 'Shared Art'),
              Tab(text: 'Interactions'),
            ],
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              children: [
                _buildUploadedArtSection(),
                _buildSharedArtSection(),
                _buildInteractionsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedArtSection() {
    return FutureBuilder<User?>(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Something went wrong'));
        }

        User? user = snapshot.data;
        if (user == null) {
          return const Center(child: Text('User not found'));
        }

        return _buildArtworkList(user.uid);
      },
    );
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Widget _buildArtworkList(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('artworks')
          .where('artistID', isEqualTo: userId)
          .snapshots(),
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
            var artworkData = artworks[index].data() as Map<String, dynamic>;
            var artworkId = artworks[index].id;
            var imageUrl = artworkData['imageUrl'] ?? '';
            var title = artworkData['artworkName'] ?? 'No title';
            var description =
                artworkData['artworkDescription'] ?? 'No description';

            return ListTile(
              leading: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                    )
                  : const Icon(Icons.image),
              title: Text(title),
              subtitle: Text(description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Add logic to edit the artwork
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Artwork'),
                          content: const Text(
                              'Are you sure you want to delete this artwork?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        await _deleteArtwork(artworkId);
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtworkPage(artworkId: artworkId),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _deleteArtwork(String artworkId) async {
    try {
      await FirebaseFirestore.instance
          .collection('artworks')
          .doc(artworkId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artwork deleted successfully')),
      );
    } catch (e) {
      print('Error deleting artwork: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete artwork')),
      );
    }
  }

  Widget _buildSharedArtSection() {
    return const Center(
      child: Text('Shared Art will be displayed here'),
    );
  }

  Widget _buildInteractionsSection() {
    return const Center(
      child: Text('Comments, Likes, and Shared Work will be displayed here'),
    );
  }
}
