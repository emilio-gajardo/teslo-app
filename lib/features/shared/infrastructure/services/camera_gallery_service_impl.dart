import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // % de calidad
    );
    if (photo == null) return null;

    if (kDebugMode) print('>> selectPhoto: ${photo.path}');
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80, // % de calidad
      preferredCameraDevice: CameraDevice.rear, // camara posterior
    );
    if (photo == null) return null;

    if (kDebugMode) print('>> takePhoto: ${photo.path}');
    return photo.path;
  }
}
