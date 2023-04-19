import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ClientModules {
  InternetConnectionChecker get connectionChecker => InternetConnectionChecker();

  Dio get dio => Dio();

  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

  ImageCropper get imageCropper => ImageCropper();

  ImagePicker get imagePicker => ImagePicker();

  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  TextRecognizer get textRecognizer => TextRecognizer();
}
