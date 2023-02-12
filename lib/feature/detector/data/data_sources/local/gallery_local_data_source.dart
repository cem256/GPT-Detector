import 'package:gpt_detector/core/utils/image_picker/image_picker.dart';

class GalleryLocalDataSource {
  GalleryLocalDataSource({required ImagePickerUtils imagePicker}) : _imagePicker = imagePicker;

  final ImagePickerUtils _imagePicker;

  Future<String?> getImagePath() async {
    final image = await _imagePicker.selectFromGallery();
    return image?.path;
  }
}
