import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/location_service.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _language = 'en';
  Position? _location;
  List<String> _mediaUrls = [];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;

    return Scaffold(
      appBar: AppBar(title: Text('Upload Product')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButton<String>(
              value: _language,
              items: [
                'en',
                'sw',
              ].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (v) => setState(() => _language = v!),
            ),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Get Location'),
            ),
            if (_location != null)
              Text('Location: ${_location!.latitude}, ${_location!.longitude}'),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Photo'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickVideo,
                    child: Text('Short Video'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed:
                  _mediaUrls.isNotEmpty && _titleController.text.isNotEmpty
                  ? _submit
                  : null,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  _getLocation() async {
    final loc = await LocationService.getCurrentLocation();
    setState(() => _location = loc);
  }

  _pickMedia() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final url = await StorageService().uploadMedia(
        File(image.path),
        user!.id,
        'images',
      );
      setState(() => _mediaUrls.add(url));
    }
  }

  _submit() async {
    final firestore = FirestoreService();
    final product = Product(
      id: '',
      userId: user!.id,
      title: _titleController.text,
      description: _descController.text,
      mediaUrls: _mediaUrls,
      location: GeoPoint(_location!.latitude, _location!.longitude),
      language: _language,
      createdAt: Timestamp.now(),
    );
    await firestore.addProduct(product);
    Navigator.pop(context);
  }
}
