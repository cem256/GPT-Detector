import 'package:gpt_detector/core/clients/image_picker/image_picker_client.dart';
import 'package:injectable/injectable.dart';

abstract interface class GalleryLocalDataSource {
  Future<String?> selectFromGallery();
}

@Injectable(as: GalleryLocalDataSource)
final class GalleryLocalDataSourceImpl implements GalleryLocalDataSource {
  GalleryLocalDataSourceImpl({required ImagePickerClient imagePicker}) : _imagePicker = imagePicker;

  final ImagePickerClient _imagePicker;

  @override
  Future<String?> selectFromGallery() async {
    final image = await _imagePicker.selectFromGallery();
    return image?.path;
  }
}
