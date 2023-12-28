abstract class CameraGalleryService {

  /// - Tomar foto con camara
  Future<String?> takePhoto();

  /// - Seleccionar imagen desde galeria
  Future<String?> selectPhoto();
  // Future<List<String>>? selectMultiplePhotos();
}