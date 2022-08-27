import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

//
class FirebaseStorageService {
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Reference storageReference = FirebaseStorage.instance.ref();

  Future<bool> addCustomerImageToStorage(
      String customerUID, File customerImage) async {
    try {
      if (customerImage != null) {
        Reference ref = storageReference.child('Users').child(
            '$customerUID.${customerImage.path.split('/').last.split('.').last}');
        final UploadTask uploadTask = ref.putFile(
          customerImage,
          SettableMetadata(
            contentLanguage: 'en',
            customMetadata: <String, String>{'activity': 'test'},
          ),
        );

        // if (uploadTask.isSuccessful) {
        return true;
        // }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> getCustomerImageLink(String imageName) async {
    print('this is the image Name $imageName');
    Reference ref = storageReference.child('Users').child(imageName);
    String imageLink = await ref.getDownloadURL();
//    print(imageLink);

    return imageLink;
  }

  Future<String> getNotificationImage(String imageName) async {
//    print('this is the image Name $imageName');
    Reference ref = storageReference.child('Notifications').child(imageName);
    String imageLink = await ref.getDownloadURL();
//    print(imageLink);

    return imageLink;
  }
}
