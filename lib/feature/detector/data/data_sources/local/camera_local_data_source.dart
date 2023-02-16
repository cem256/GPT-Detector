import 'package:gpt_detector/core/clients/image_picker/image_picker_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class CameraLocalDataSource {
  CameraLocalDataSource({required ImagePickerClient imagePicker}) : _imagePicker = imagePicker;

  final ImagePickerClient _imagePicker;

  Future<String?> takePhoto() async {
    final image = await _imagePicker.takePhoto();
    return image?.path;
  }
}
