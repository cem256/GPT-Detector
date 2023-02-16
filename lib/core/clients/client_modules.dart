import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@module
abstract class ClientModules {
  @injectable
  InternetConnectionChecker get connectionChecker => InternetConnectionChecker();

  @injectable
  Dio get dio => Dio();

  @injectable
  ImageCropper get imageCropper => ImageCropper();

  @injectable
  ImagePicker get imagePicker => ImagePicker();

  @injectable
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @injectable
  TextRecognizer get textRecognizer => TextRecognizer();
}
