import 'dart:io';
import 'package:artgallery/utilities/firebase/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentProfilePictureUrl;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentBio,
    required this.currentProfilePictureUrl,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _profilePictureUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _bioController.text = widget.currentBio;
    _profilePictureUrl = widget.currentProfilePictureUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_pictures')
              .child(user.uid);
          await storageRef.putFile(File(pickedFile.path));
          final downloadUrl = await storageRef.getDownloadURL();
          setState(() {
            _profilePictureUrl = downloadUrl;
          });
        }
      } catch (e) {
        print('Error uploading profile picture: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('artists')
            .doc(user.uid)
            .update({
          'artistUsername': _nameController.text,
          'bio': _bioController.text,
          'profilePictureUrl': _profilePictureUrl,
        });

        Navigator.pop(context, {
          'name': _nameController.text,
          'bio': _bioController.text,
          'profilePictureUrl': _profilePictureUrl,
        });
      }
    } catch (e) {
      print('Error updating profile: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePictureUrl != null
                          ? NetworkImage(_profilePictureUrl!)
                          : null,
                      child: _profilePictureUrl == null
                          ? const Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
