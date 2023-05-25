import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_camera_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_gallery_use_case.dart';
import 'package:gpt_detector/feature/detector/presentation/cubit/detector_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectUseCase extends Mock implements DetectUseCase {}

class MockOCRFromGalleryUseCase extends Mock implements OCRFromGalleryUseCase {}

class MockOCRFromCameraUseCase extends Mock implements OCRFromCameraUseCase {}

class MockDetectorEntity extends Mock implements DetectorEntity {}

String generateRandomString(int len) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(
      len,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}

void main() {
  late DetectorCubit detectorCubit;
  late MockDetectUseCase mockDetectUseCase;
  late MockOCRFromGalleryUseCase mockOCRFromGalleryUseCase;
  late MockOCRFromCameraUseCase mockOCRFromCameraUseCase;
  late MockDetectorEntity mockDetectorEntity;
  late String validUserInput;
  late UserInputForm validInputForm;
  late String invalidUserInput;
  late UserInputForm invalidInputForm;

  setUp(() {
    mockDetectUseCase = MockDetectUseCase();
    mockOCRFromGalleryUseCase = MockOCRFromGalleryUseCase();
    mockOCRFromCameraUseCase = MockOCRFromCameraUseCase();
    detectorCubit = DetectorCubit(
      detectUseCase: mockDetectUseCase,
      ocrFromGalleryUseCase: mockOCRFromGalleryUseCase,
      ocrFromCameraUseCase: mockOCRFromCameraUseCase,
    );
    mockDetectorEntity = MockDetectorEntity();
    validUserInput = generateRandomString(200);
    validInputForm = UserInputForm.dirty(validUserInput);
    invalidUserInput = '';
    invalidInputForm = UserInputForm.dirty(invalidUserInput);
  });
  group('DetectorCubit.detectionRequested()', () {
    test("Initial value of the 'status' variable must be 'FormzStatus.pure' at start", () {
      expect(detectorCubit.state.status, FormzStatus.pure);
    });

    test(
        "Default value of the 'result' variable must be \"(DetectorEntity(fakeProb: 0.00, realProb: 0.00, allTokens: 0)\" at start",
        () {
      expect(
        detectorCubit.state.result,
        const DetectorEntity(fakeProb: 0, realProb: 0, allTokens: 0),
      );
    });

    blocTest<DetectorCubit, DetectorState>(
      'It should emit FormzStatus.submissionFailure when Left type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(validUserInput)).thenAnswer(
          (_) async => const Left(Failure.networkFailure()),
        );
      },
      build: () => detectorCubit,
      act: (bloc) => bloc.detectionRequested(text: validUserInput),
      expect: () => [
        DetectorState(status: FormzStatus.submissionInProgress),
        DetectorState(
          status: FormzStatus.submissionFailure,
          failure: const Failure.networkFailure(),
        ),
      ],
    );

    blocTest<DetectorCubit, DetectorState>(
      'It should emit FormzStatus.submissionInProgress and a DetectorEntity instance when Right type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(validUserInput)).thenAnswer(
          (_) async => Right(mockDetectorEntity),
        );
      },
      build: () => detectorCubit,
      act: (bloc) => bloc.detectionRequested(text: validUserInput),
      expect: () => [
        DetectorState(status: FormzStatus.submissionInProgress),
        DetectorState(
          result: mockDetectorEntity,
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );
  });
  group('DetectorCubit.textChanged()', () {
    blocTest<DetectorCubit, DetectorState>(
      'It should emit a userInput and FormzStatus.invalid when input is empty',
      build: () => detectorCubit,
      act: (bloc) => bloc.textChanged(text: invalidUserInput),
      expect: () => [
        DetectorState(userInput: invalidInputForm, status: Formz.validate([invalidInputForm])),
      ],
    );

    blocTest<DetectorCubit, DetectorState>(
      ' It should emit a userInput and FormzStatus.valid when input is not empty',
      build: () => detectorCubit,
      act: (bloc) => bloc.textChanged(text: validUserInput),
      expect: () => [
        DetectorState(userInput: validInputForm, status: Formz.validate([validInputForm])),
      ],
    );
  });

  group('DetectorCubit.clearTextPressed()', () {
    blocTest<DetectorCubit, DetectorState>(
      'It should emit a new DetectorState()',
      build: () => detectorCubit,
      act: (bloc) => bloc.clearTextPressed(),
      expect: () => [
        DetectorState(),
      ],
    );
  });

  group('DetectorCubit.ocrFromGalleryPressed()', () {
    blocTest<DetectorCubit, DetectorState>(
      'It should emit Failure object when left is returned',
      setUp: () {
        when(() => mockOCRFromGalleryUseCase()).thenAnswer(
          (_) async => const Left(Failure.noPermission()),
        );
      },
      build: () => detectorCubit,
      act: (bloc) => bloc.ocrFromGalleryPressed(),
      expect: () => [
        DetectorState(
          failure: const Failure.noPermission(),
        ),
      ],
    );

    blocTest<DetectorCubit, DetectorState>(
      'It should emit userInput and FormzStatus.valid  when Right is returned',
      setUp: () {
        when(() => mockOCRFromGalleryUseCase()).thenAnswer(
          (_) async => Right(validUserInput),
        );
      },
      build: () => detectorCubit,
      act: (bloc) => bloc.ocrFromGalleryPressed(),
      expect: () => [
        DetectorState(
          userInput: validInputForm,
          status: FormzStatus.valid,
        ),
      ],
    );
  });

  group('DetectorCubit.ocrFromCameraPressed()', () {
    blocTest<DetectorCubit, DetectorState>(
      'It should emit Failure object when left is returned',
      setUp: () {
        when(() => mockOCRFromCameraUseCase()).thenAnswer(
          (_) async => const Left(Failure.noPermission()),
        );
      },
      build: () => detectorCubit,
      act: (bloc) => bloc.ocrFromCameraPressed(),
      expect: () => [
        DetectorState(
          failure: const Failure.noPermission(),
        ),
      ],
    );

    blocTest<DetectorCubit, DetectorState>(
      'It should emit userInput and FormzStatus.valid  when Right is returned',
      setUp: () {
        when(() => mockOCRFromCameraUseCase()).thenAnswer(
          (_) async => Right(validUserInput),
        );
      },
      build: () => detectorCubit,
      act: (bloc) => bloc.ocrFromCameraPressed(),
      expect: () => [
        DetectorState(
          userInput: validInputForm,
          status: FormzStatus.valid,
        ),
      ],
    );
  });
}
