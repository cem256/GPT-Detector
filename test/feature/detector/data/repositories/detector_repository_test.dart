import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/core/clients/image_cropper/imge_cropper_client.dart';
import 'package:gpt_detector/core/clients/network_info/network_info_client.dart';
import 'package:gpt_detector/core/clients/permission_client/permission_client.dart';
import 'package:gpt_detector/core/clients/text_recognizer/text_recognizer_client.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/camera_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/local/gallery_local_data_source.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/remote/detector_remote_data_source.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/data/repositories/detector_repository_impl.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectorRemoteDataSource extends Mock implements DetectorRemoteDataSource {}

class MockGalleryLocalDataSource extends Mock implements GalleryLocalDataSource {}

class MockCameraLocalDataSource extends Mock implements CameraLocalDataSource {}

class MockPermissionClient extends Mock implements PermissionClient {}

class MockImageCropperClient extends Mock implements ImageCropperClient {}

class MockTextRecognizerClient extends Mock implements TextRecognizerClient {}

class MockNetworkInfoClient extends Mock implements NetworkInfoClient {}

class MockDetectorModel extends Mock implements DetectorModel {}

void main() {
  late MockDetectorRemoteDataSource detectorRemoteDataSource;
  late MockGalleryLocalDataSource galleryLocalDataSource;
  late MockCameraLocalDataSource cameraLocalDataSource;
  late MockPermissionClient permissionClient;
  late MockImageCropperClient imageCropperClient;
  late MockTextRecognizerClient textRecognizerClient;
  late MockNetworkInfoClient mockNetworkInfoClient;
  late DetectorRepository detectorRepository;
  late MockDetectorModel mockDetectorModel;
  late String userInput;

  setUp(() {
    detectorRemoteDataSource = MockDetectorRemoteDataSource();
    galleryLocalDataSource = MockGalleryLocalDataSource();
    cameraLocalDataSource = MockCameraLocalDataSource();
    permissionClient = MockPermissionClient();
    imageCropperClient = MockImageCropperClient();
    textRecognizerClient = MockTextRecognizerClient();
    mockNetworkInfoClient = MockNetworkInfoClient();
    detectorRepository = DetectorRepositoryImpl(
      detectorRemoteDataSource: detectorRemoteDataSource,
      galleryLocalDataSource: galleryLocalDataSource,
      cameraLocalDataSource: cameraLocalDataSource,
      permissionClient: permissionClient,
      imageCropperClient: imageCropperClient,
      textRecognizerClient: textRecognizerClient,
      networkInfoClient: mockNetworkInfoClient,
    );
    mockDetectorModel = MockDetectorModel();
    userInput = 'Test Input';
  });

  group('Check the device connection', () {
    test('Case: Device is online', () {
      when(() => mockNetworkInfoClient.isConnected).thenAnswer((_) async => true);
    });

    test('Case: Device is offline', () {
      when(() => mockNetworkInfoClient.isConnected).thenAnswer((_) async => false);
    });
  });

  group('Detect Requests', () {
    test('Should return  Detector Entity when there is no exception', () async {
      when(() => mockNetworkInfoClient.isConnected).thenAnswer((_) async => true);
      when(() => detectorRemoteDataSource.detect(userInput)).thenAnswer((_) async => mockDetectorModel);
      final result = await detectorRepository.detect(userInput);

      verify(() => detectorRemoteDataSource.detect(userInput));
      expect(result, isA<Right<Failure, DetectorEntity>>());
    });

    test('Should return Failure type of object when an exception caught', () async {
      when(() => mockNetworkInfoClient.isConnected).thenAnswer((_) async => true);
      when(() => detectorRemoteDataSource.detect(userInput)).thenThrow(Exception());
      final result = await detectorRepository.detect(userInput);

      verify(() => detectorRemoteDataSource.detect(userInput));
      expect(result, isA<Left<Failure, DetectorEntity>>());
    });
  });
}
