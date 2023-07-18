import 'package:gpt_detector/core/clients/image_picker/image_picker_client.dart';
import 'package:injectable/injectable.dart';

abstract interface class CameraLocalDataSource {
  Future<String?> takePhoto();
}

@Injectable(as: CameraLocalDataSource)
final class CameraLocalDataSourceImpl implements CameraLocalDataSource {
  CameraLocalDataSourceImpl({required ImagePickerClient imagePicker}) : _imagePicker = imagePicker;

  final ImagePickerClient _imagePicker;

  @override
  Future<String?> takePhoto() async {
    final image = await _imagePicker.takePhoto();
    return image?.path;
  }
}
