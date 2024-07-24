import 'package:artgallery/utilities/firebase/firebase_auth_services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:artgallery/utilities/navigation_menu.dart';
import 'package:artgallery/models/artwork.dart';
import 'package:artgallery/views/artwork_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthServices _authService = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.upload),
              label: const Text('Upload'),
              onPressed: () => _showUploadDialog(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: const Center(),
      bottomNavigationBar: const NavigationMenu(currentIndex: 0),
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        File? _imageFile;
        String? _imageFileUrl; // For web
        bool _uploadError = false;
        String? _errorMessage;
        final TextEditingController _titleController = TextEditingController();
        final TextEditingController _descriptionController =
            TextEditingController();
        final ImagePicker _picker = ImagePicker();

        Future<void> _pickImage() async {
          final XFile? pickedFile =
              await _picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {
              if (kIsWeb) {
                _imageFileUrl = pickedFile.path;
              } else {
                _imageFile = File(pickedFile.path);
              }
            });
          }
        }

        Future<void> _uploadArtwork() async {
          if ((kIsWeb && _imageFileUrl == null) ||
              (!kIsWeb && _imageFile == null) ||
              _titleController.text.isEmpty ||
              _descriptionController.text.isEmpty) {
            return;
          }

          try {
            String fileName = kIsWeb
                ? _imageFileUrl!.split('/').last
                : _imageFile!.path.split('/').last;
            Reference storageRef =
                FirebaseStorage.instance.ref().child('artworks/$fileName');
            UploadTask uploadTask = kIsWeb
                ? storageRef.putData(await XFile(_imageFileUrl!).readAsBytes())
                : storageRef.putFile(_imageFile!);

            uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
              print('Task state: ${snapshot.state}');
              print(
                  'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
            }, onError: (e) {
              print('Error during upload: $e');
              setState(() {
                _uploadError = true;
                _errorMessage = e.toString();
              });
            });

            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadUrl = await taskSnapshot.ref.getDownloadURL();

            String? currentArtistId = _auth.currentUser?.uid;
            if (currentArtistId != null) {
              DocumentSnapshot artistSnapshot = await FirebaseFirestore.instance
                  .collection('artists')
                  .doc(currentArtistId)
                  .get();
              Map<String, dynamic>? artistData =
                  artistSnapshot.data() as Map<String, dynamic>?;
              String artistUsername = artistData?['artistUsername'] ?? '';

              DocumentReference docRef =
                  await FirebaseFirestore.instance.collection('artworks').add({
                'artworkID': '',
                'artistID': currentArtistId,
                'artistUsername': artistUsername,
                'artworkName': _titleController.text,
                'artworkDescription': _descriptionController.text,
                'imageUrl': downloadUrl,
                'artworkCreate': DateTime.now(),
              });

              String artworkId = docRef.id;
              await docRef.update({'artworkID': artworkId});

              await addArtworkToArtist(currentArtistId, artworkId);

              print("Artwork ID: $artworkId");

              if (artworkId.isNotEmpty) {
                if (WidgetsBinding.instance != null) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtworkPage(artworkId: artworkId),
                      ),
                    );
                  });
                }
              } else {
                setState(() {
                  _uploadError = true;
                  _errorMessage = "Failed to retrieve artwork ID.";
                });
              }
            } else {
              setState(() {
                _uploadError = true;
                _errorMessage = "User not authenticated.";
              });
            }
          } catch (e) {
            setState(() {
              _uploadError = true;
              _errorMessage = e.toString();
            });
            print('Error uploading artwork: $e');
          }
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text('Upload Artwork'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickImage();
                        setStateDialog(() {});
                      },
                      child: const Text('Select Image'),
                    ),
                    if (_imageFile != null || _imageFileUrl != null) ...[
                      const SizedBox(height: 10),
                      kIsWeb
                          ? Image.network(_imageFileUrl!, height: 100)
                          : Image.file(_imageFile!, height: 100),
                    ],
                    if (_uploadError) ...[
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage ??
                            'Something went wrong. Please try again.',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _uploadArtwork();
                    setStateDialog(() {});
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> addArtworkToArtist(String artistId, String artworkId) async {
    try {
      await FirebaseFirestore.instance
          .collection('artists')
          .doc(artistId)
          .update({
        'artworkIds': FieldValue.arrayUnion([artworkId]),
      });
    } catch (e) {
      print('Error adding artwork to artist: $e');
    }
  }
}
