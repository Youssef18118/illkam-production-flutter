import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io' as io;
import 'imagePicker_web.dart' if (dart.library.html) 'imagePicker_web_impl.dart';
import 'package:image_cropper/image_cropper.dart';

enum PickUsageType { PROFILE, ILLKAM, COMMUNITY, CHAT, REVIEW }

Future<String?> pickImage(PickUsageType type) async {
  if (kIsWeb) {
    // 웹 환경
    return await pickImageWeb();
  } else {
    // 모바일 환경 (기존 ImagePicker 사용)
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      io.File? img = await resizeAndGetPng(cropImage: io.File(pickedFile.path));
      if (img != null) {
        switch (type) {
          case PickUsageType.COMMUNITY:
            return await uploadImageToFirebase(img, 'article');
          case PickUsageType.ILLKAM:
            return await uploadImageToFirebase(img, 'illkam');
          case PickUsageType.PROFILE:
            return await uploadImageToFirebase(img, 'profile');
          case PickUsageType.REVIEW:
            return await uploadImageToFirebase(img, 'review');
          case PickUsageType.CHAT:
            String? imageURL = await uploadImageToFirebase(img, 'chats');
            return imageURL;
          default:
            break;
        }
      }
      return '';
    }
  }
  return null;
}

Future<String?> uploadImageToFirebase(io.File file, String foldername) async {
  try {
    // 파일 이름을 유니크하게 지정
    String fileName =
        '$foldername/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Firebase Storage 참조 생성
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    // 파일 업로드
    final uploadTask = await storageRef.putFile(file);

    // 업로드 완료 후 다운로드 가능한 URL 가져오기
    final downloadUrl = await storageRef.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}



Future<io.File?> cropImage({required io.File imageFile}) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  );
  if (croppedImage == null) {
    return null;
  }

  return io.File(croppedImage.path);
}

// 리사이징 및 포맷변환
Future<io.File?> resizeAndGetPng({required io.File cropImage}) async {
  io.File targetImage = io.File(cropImage.path);
  print('이미지 경로:${targetImage.path}');
  double targetImageSize =
      double.parse((targetImage.lengthSync() / 1024).toStringAsFixed(2));

  print('리사이징 before: $targetImageSize KB');
  int originMin = 720;
  while (targetImageSize > 100) {
    var compressedImage = await FlutterImageCompress.compressAndGetFile(
        targetImage.path, '${targetImage.path}_resizedImg.png',
        format: CompressFormat.png, minHeight: originMin, minWidth: originMin);
    if (compressedImage == null) {
      break;
    }
    targetImageSize = double.parse(
        (await compressedImage.length() / 1024).toStringAsFixed(2));
    targetImage = io.File(compressedImage.path);
    print('리사이징 중: $targetImageSize KB');
    originMin = originMin ~/ 1.5;
  }

  print('리사이징 after: $targetImageSize KB');

  return targetImage;
}
