import 'package:artgallery/utilities/directoryrouter.dart';
import 'package:artgallery/utilities/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, String>> uploadedArt = [
    {"title": "Sunset", "description": "A beautiful sunset", "imageUrl": "assets/sunset.jpg"},
    {"title": "Mountain", "description": "A majestic mountain", "imageUrl": "assets/mountain.jpg"},
  ];

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
    return ListView.builder(
      itemCount: uploadedArt.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(uploadedArt[index]["imageUrl"]!),
          title: Text(uploadedArt[index]["title"]!),
          subtitle: Text(uploadedArt[index]["description"]!),
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
                onPressed: () {
                  // Add logic to delete the artwork
                },
              ),
            ],
          ),
        );
      },
    );
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
