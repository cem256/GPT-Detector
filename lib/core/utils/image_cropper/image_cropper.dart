// ignore_for_file: one_member_abstracts

import 'package:gpt_detector/app/theme/app_theme.dart';
import 'package:gpt_detector/injection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';

abstract class ImageCropperUtils {
  Future<String?> cropPhoto({required String filePath});
}

@LazySingleton(as: ImageCropperUtils)
class ImageCropperUtilsImpl implements ImageCropperUtils {
  final ImageCropper _imageCropper = ImageCropper();
  @override
  Future<String?> cropPhoto({required String filePath}) async {
    final file = await _imageCropper.cropImage(
      sourcePath: filePath,
      compressQuality: 100,
      aspectRatioPresets: _aspectRatioPresets,
      uiSettings: _uiSettings,
    );

    return file?.path;
  }

  List<CropAspectRatioPreset> get _aspectRatioPresets {
    return [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
    ];
  }

  List<PlatformUiSettings> get _uiSettings {
    return [
      AndroidUiSettings(
        toolbarTitle: 'Edit Photo',
        toolbarColor: getIt<AppTheme>().theme.primaryColor,
        toolbarWidgetColor: getIt<AppTheme>().theme.scaffoldBackgroundColor,
        activeControlsWidgetColor: getIt<AppTheme>().theme.primaryColor,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        showCropGrid: false,
      ),
      IOSUiSettings(
        title: 'Edit Photo',
      )
    ];
  }
}
