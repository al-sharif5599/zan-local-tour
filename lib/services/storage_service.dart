import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadMedia(File file, String userId, String type) async {
    String fileName = path.basename(file.path);
    String refPath = 'products/$userId/$type/$fileName';
    UploadTask uploadTask = _storage.ref().child(refPath).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
