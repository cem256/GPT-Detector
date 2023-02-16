import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_camera_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectorRepository extends Mock implements DetectorRepository {}

void main() {
  late MockDetectorRepository mockDetectorRepository;
  late OCRFromCameraUseCase ocrFromCameraUseCase;
  late String ocrFromCameraResult;

  setUp(() {
    mockDetectorRepository = MockDetectorRepository();
    ocrFromCameraUseCase = OCRFromCameraUseCase(detectorRepository: mockDetectorRepository);
    ocrFromCameraResult = 'Test result';
  });

  group('OCR from camera Use Case Test', () {
    test('Should return a String when no exception caught', () async {
      when(() => mockDetectorRepository.ocrFromCamera()).thenAnswer((_) async => Right(ocrFromCameraResult));
      final result = await ocrFromCameraUseCase();

      verify(() => ocrFromCameraUseCase());
      expect(result, isA<Right<Failure, String>>());
    });

    test('Should return Failure type of object when an exception caught', () async {
      when(() => mockDetectorRepository.ocrFromCamera()).thenAnswer((_) async => const Left(Failure.noPermission()));
      final result = await ocrFromCameraUseCase();

      verify(() => ocrFromCameraUseCase());
      expect(result, isA<Left<Failure, String>>());
    });
  });
}
