import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_gallery_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectorRepository extends Mock implements DetectorRepository {}

void main() {
  late MockDetectorRepository mockDetectorRepository;
  late OCRFromGalleryUseCase ocrFromGalleryUseCase;
  late String ocrFromGalleryResult;

  setUp(() {
    mockDetectorRepository = MockDetectorRepository();
    ocrFromGalleryUseCase = OCRFromGalleryUseCase(detectorRepository: mockDetectorRepository);
    ocrFromGalleryResult = 'Test result';
  });

  group('OCR from gallery Use Case Test', () {
    test('Should return a String when no exception caught', () async {
      when(() => mockDetectorRepository.ocrFromGallery()).thenAnswer((_) async => Right(ocrFromGalleryResult));
      final result = await ocrFromGalleryUseCase();

      verify(() => ocrFromGalleryUseCase());
      expect(result, isA<Right<Failure, String>>());
    });

    test('Should return Failure type of object when an exception caught', () async {
      when(() => mockDetectorRepository.ocrFromGallery()).thenAnswer((_) async => const Left(Failure.noPermission()));
      final result = await ocrFromGalleryUseCase();

      verify(() => ocrFromGalleryUseCase());
      expect(result, isA<Left<Failure, String>>());
    });
  });
}
