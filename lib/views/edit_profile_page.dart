import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentProfilePictureUrl;

  const EditProfilePage({
    Key? key,
    required this.currentName,
    required this.currentBio,
    required this.currentProfilePictureUrl,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late String _profilePictureUrl;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _bioController = TextEditingController(text: widget.currentBio);
    _profilePictureUrl = widget.currentProfilePictureUrl;
  }

  void _saveChanges() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'bio': _bioController.text,
      'profilePictureUrl': _profilePictureUrl,
    });
  }

  void _checkForChanges() {
    setState(() {
      _isChanged = _nameController.text != widget.currentName || _bioController.text != widget.currentBio || _profilePictureUrl != widget.currentProfilePictureUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    _nameController.addListener(_checkForChanges);
    _bioController.addListener(_checkForChanges);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Logic to change profile picture
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(_profilePictureUrl),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 20),
            if (_isChanged)
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
          ],
        ),
      ),
    );
  }
}
