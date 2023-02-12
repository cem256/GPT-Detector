import 'package:gpt_detector/core/utils/image_picker/image_picker.dart';

class CameraLocalDataSource {
  CameraLocalDataSource({required ImagePickerUtils imagePicker}) : _imagePicker = imagePicker;

  final ImagePickerUtils _imagePicker;

  Future<String?> takePhoto() async {
    final image = await _imagePicker.takePhoto();
    return image?.path;
  }
}
