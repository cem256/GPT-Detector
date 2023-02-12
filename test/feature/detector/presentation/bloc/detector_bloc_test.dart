import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';

import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_gallery_use_case.dart';
import 'package:gpt_detector/feature/detector/presentation/bloc/detector_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectUseCase extends Mock implements DetectUseCase {}

class MockOCRFromGalleryUseCase extends Mock implements OCRFromGalleryUseCase {}

class MockDetectorEntity extends Mock implements DetectorEntity {}

void main() {
  late DetectorBloc detectorBloc;
  late MockDetectUseCase mockDetectUseCase;
  late MockOCRFromGalleryUseCase mockOCRFromGalleryUseCase;
  late MockDetectorEntity mockDetectorEntity;
  late String userInput;

  setUp(() {
    mockDetectUseCase = MockDetectUseCase();
    mockOCRFromGalleryUseCase = MockOCRFromGalleryUseCase();
    detectorBloc = DetectorBloc(
      detectUseCase: mockDetectUseCase,
      ocrFromGalleryUseCase: mockOCRFromGalleryUseCase,
    );
    mockDetectorEntity = MockDetectorEntity();
    userInput = 'Test Input';
  });
  group('Detector Bloc Tests', () {
    test("Initial value of the 'status' variable must be 'FormzStatus.pure' at start", () {
      expect(detectorBloc.state.status, FormzStatus.pure);
    });

    test(
        "Default value of the 'result' variable must be \"(DetectorEntity(fakeProb: 0.00, realProb: 0.00, allTokens: 0)\" at start",
        () {
      expect(
        detectorBloc.state.result,
        const DetectorEntity(fakeProb: 0, realProb: 0, allTokens: 0),
      );
    });

    blocTest<DetectorBloc, DetectorState>(
      'DetectorEvent.detectionRequested() event test case: It should emit FormzStatus.submissionFailure when Left type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(userInput)).thenAnswer(
          (_) async => const Left(Failure.networkFailure()),
        );
      },
      build: () => detectorBloc,
      act: (bloc) => bloc.add(DetectorEvent.detectionRequested(userInput: userInput)),
      expect: () => [
        DetectorState(status: FormzStatus.submissionInProgress),
        DetectorState(
          status: FormzStatus.submissionFailure,
          failure: const Failure.networkFailure(),
        ),
      ],
    );

    blocTest<DetectorBloc, DetectorState>(
      'DetectorEvent.detectionRequested() event test case: It should emit FormzStatus.submissionInProgress and a DetectorEntity instance when Right type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(userInput)).thenAnswer(
          (_) async => Right(mockDetectorEntity),
        );
      },
      build: () => detectorBloc,
      act: (bloc) => bloc.add(DetectorEvent.detectionRequested(userInput: userInput)),
      expect: () => [
        DetectorState(status: FormzStatus.submissionInProgress),
        DetectorState(
          result: mockDetectorEntity,
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );
  });

  blocTest<DetectorBloc, DetectorState>(
    'DetectorEvent.clearTextPressed() event test case: It should emit a new DetectorState()',
    build: () => detectorBloc,
    act: (bloc) => bloc.add(const DetectorEvent.clearTextPressed()),
    expect: () => [
      DetectorState(),
    ],
  );
}
