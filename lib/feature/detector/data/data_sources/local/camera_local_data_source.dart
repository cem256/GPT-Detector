import 'package:gpt_detector/core/image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CameraLocalDataSource {
  CameraLocalDataSource({required ImagePickerUtils imagePicker}) : _imagePicker = imagePicker;

  final ImagePickerUtils _imagePicker;

  Future<String?> takePhoto() async {
    final image = await _imagePicker.takePhoto();
    return image?.path;
  }
}
