import 'package:gpt_detector/core/image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GalleryLocalDataSource {
  GalleryLocalDataSource({required ImagePickerUtils imagePicker}) : _imagePicker = imagePicker;

  final ImagePickerUtils _imagePicker;

  Future<String?> selectFromGallery() async {
    final image = await _imagePicker.selectFromGallery();
    return image?.path;
  }
}
