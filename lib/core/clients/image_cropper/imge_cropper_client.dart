import 'package:gpt_detector/app/theme/light/light_theme.dart';
import 'package:gpt_detector/locator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';

abstract interface class ImageCropperClient {
  Future<String?> cropPhoto({required String filePath});
}

@Injectable(as: ImageCropperClient)
final class ImageCropperClientImpl implements ImageCropperClient {
  ImageCropperClientImpl({required ImageCropper imageCropper}) : _imageCropper = imageCropper;

  final ImageCropper _imageCropper;
  @override
  Future<String?> cropPhoto({required String filePath}) async {
    final file = await _imageCropper.cropImage(
      sourcePath: filePath,
      compressQuality: 100,
      uiSettings: _uiSettings,
    );

    return file?.path;
  }

  final List<CropAspectRatioPreset> _aspectRatioPresets = [
    CropAspectRatioPreset.original,
    CropAspectRatioPreset.square,
    CropAspectRatioPreset.ratio4x3,
    CropAspectRatioPreset.ratio16x9,
  ];

  List<PlatformUiSettings> get _uiSettings => [
        AndroidUiSettings(
          toolbarTitle: 'Edit Photo',
          toolbarColor: Locator.instance<LightTheme>().theme.colorScheme.primary,
          toolbarWidgetColor: Locator.instance<LightTheme>().theme.colorScheme.surface,
          activeControlsWidgetColor: Locator.instance<LightTheme>().theme.colorScheme.primary,
          aspectRatioPresets: _aspectRatioPresets,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          showCropGrid: false,
        ),
        IOSUiSettings(
          title: 'Edit Photo',
          aspectRatioPresets: _aspectRatioPresets,
        ),
      ];
}
