// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebasApi {
  static UploadTask? uploadFile(String destination, File file) {
    final ref = FirebaseStorage.instance.ref(destination);

    return ref.putFile(file);
  }
}
