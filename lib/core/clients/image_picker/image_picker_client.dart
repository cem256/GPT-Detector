import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract interface class ImagePickerClient {
  Future<XFile?> selectFromGallery();
  Future<XFile?> takePhoto();
}

@Injectable(as: ImagePickerClient)
final class ImagePickerClientImpl implements ImagePickerClient {
  ImagePickerClientImpl({required ImagePicker imagePicker}) : _imagePicker = imagePicker;

  final ImagePicker _imagePicker;

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
