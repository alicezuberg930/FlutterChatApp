import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileFirebase {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<String> uploadImage(File imageFile, String path) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = storage.ref().child("$path/$fileName");
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    return await taskSnapshot.ref.getDownloadURL();
  }
}