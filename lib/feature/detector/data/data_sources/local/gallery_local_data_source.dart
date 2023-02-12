import 'package:gpt_detector/core/utils/image_picker/image_picker.dart';
import 'package:gpt_detector/core/utils/permission_handler/permission_handler.dart';

class GalleryLocalDataSource {
  GalleryLocalDataSource({
    required PermissionHandlerUtils permissionHandler,
    required ImagePickerUtils imagePicker,
  })  : _permissionHandler = permissionHandler,
        _imagePicker = imagePicker;

  final PermissionHandlerUtils _permissionHandler;
  final ImagePickerUtils _imagePicker;

  Future<String?> getImagePath() async {
    final hasPermission = await _permissionHandler.hasGalleryPermission();
    if (hasPermission) {
      final image = await _imagePicker.selectFromGallery();
      return image?.path;
    }
    return null;
  }
}
