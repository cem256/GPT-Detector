import 'package:image_picker/image_picker.dart';

abstract class ImagePickerUtils {
  Future<XFile?> selectFromGallery();
  Future<XFile?> takePhoto();
}

class ImagePickerUtilsImpl implements ImagePickerUtils {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<XFile?> selectFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Future<XFile?> takePhoto() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    return image;
  }
}