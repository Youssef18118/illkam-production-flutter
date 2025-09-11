// imagePicker_web_impl.dart (웹용)

import 'dart:html' as html;
import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> pickImageWeb() async {
  final completer = Completer<String?>();

  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files!.isEmpty) {
      completer.completeError('No file selected');
      return;
    }

    final file = files[0];

    try {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((e) async {
        String? downloadUrl = await uploadImageToFirebaseWeb(file);
        completer.complete(downloadUrl);
      });

      reader.onError.listen((e) {
        completer.completeError('Failed to read file');
      });

    } catch (e) {
      completer.completeError('Error processing image: $e');
    }
  });

  return completer.future;
}

Future<String?> uploadImageToFirebaseWeb(html.File file) async {
  try {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child('web_images/$fileName');

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    await reader.onLoadEnd.first;
    final uploadTask = await storageRef.putData(reader.result as Uint8List);

    final downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}