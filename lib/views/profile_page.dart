import 'package:artgallery/utilities/firebase/firebase_auth_services.dart';
import 'package:artgallery/utilities/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'artwork_page.dart';
import 'package:artgallery/views/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String bio = "Artist and photographer.";
  String profilePictureUrl =
      'https://www.pngkey.com/png/detail/115-1150152_default-profile-picture-avatar-png-green.png';
  String username = "Your Name";
  bool isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final FirebaseAuthServices authService = FirebaseAuthServices();
      final currentUser = await authService.getCurrentUser();
      final userId = widget.userId ?? currentUser?.uid;

      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('artists')
            .doc(userId)
            .get();
        final userName = userDoc.data()?['artistUsername'] ?? username;
        final profilePicUrl =
            userDoc.data()?['profilePictureUrl'] ?? profilePictureUrl;
        final userBio = userDoc.data()?['bio'] ?? bio;

        setState(() {
          username = userName;
          profilePictureUrl = profilePicUrl;
          bio = userBio;
          isCurrentUser = currentUser != null && currentUser.uid == userId;
        });
      }
    } catch (e) {
      print("Failed to load user profile: $e");
    }
  }

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
            backgroundImage: NetworkImage(profilePictureUrl),
          ),
          const SizedBox(height: 10),
          Text(
            username,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            bio,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          if (isCurrentUser)
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      currentName: username,
                      currentBio: bio,
                      currentProfilePictureUrl: profilePictureUrl,
                    ),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    username = result['name'] as String;
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

        final userId = widget.userId ?? user.uid;
        return _buildArtworkList(userId);
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
              trailing: isCurrentUser
                  ? Row(
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
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
                    )
                  : null,
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
