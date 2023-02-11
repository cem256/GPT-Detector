import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/app/errors/failure.dart';

import 'package:gpt_detector/core/network/network_info.dart';
import 'package:gpt_detector/feature/detector/data/data_sources/remote/detector_remote_data_source.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';
import 'package:gpt_detector/feature/detector/data/repositories/detector_repository_impl.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectorRemoteDataSource extends Mock implements DetectorRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockDetectorModel extends Mock implements DetectorModel {}

void main() {
  late MockDetectorRemoteDataSource detectorRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late DetectorRepository detectorRepository;
  late MockDetectorModel mockDetectorModel;
  late String userInput;

  setUp(() {
    detectorRemoteDataSource = MockDetectorRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    detectorRepository = DetectorRepositoryImpl(
      detectorRemoteDataSource: detectorRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockDetectorModel = MockDetectorModel();
    userInput = 'Test Input';
  });

  group('Check the device connection', () {
    test('Case: Device is online', () {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('Case: Device is offline', () {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
  });

  group('Detect Requests', () {
    test('Should return  Detector Entity when there is no exception', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => detectorRemoteDataSource.detect(userInput)).thenAnswer((_) async => mockDetectorModel);
      final result = await detectorRepository.detect(userInput);

      verify(() => detectorRemoteDataSource.detect(userInput));
      expect(result, isA<Right<Failure, DetectorEntity>>());
    });
  });

  test('Should return Failure type of object when an exception caught', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => detectorRemoteDataSource.detect(userInput)).thenThrow(Exception());
    final result = await detectorRepository.detect(userInput);

    verify(() => detectorRemoteDataSource.detect(userInput));
    expect(result, isA<Left<Failure, DetectorEntity>>());
  });
}
