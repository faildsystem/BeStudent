import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student/core/widgets/firestore_functions.dart';

class ProfilePic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> pickUploadPic() async {
    final currentUser = _auth.currentUser!;

    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    if (image == null) {
      return '';
    }

    final userId = currentUser.uid;
    final storeRef =
        _storage.ref().child("images/${userId.toLowerCase()}_profilepic.jpg");

    try {
      await storeRef.putFile(File(image.path));
      final downloadUrl = await storeRef.getDownloadURL();
      FireStoreFunctions.updateUser(userId, imageUrl: downloadUrl);
      return downloadUrl;
    } catch (e) {
      log("Error: $e");
    }
  }
}