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
    validUserInput = generateRandomString(250);
    validInputForm = UserInputForm.dirty(validUserInput);
    invalidUserInput = '';
    invalidInputForm = UserInputForm.dirty(invalidUserInput);
  });
  group('DetectorCubit.detectionRequested()', () {
    test("Initial value of the 'status' variable must be 'FormzStatus.pure' at start", () {
      expect(detectorCubit.state.status, FormzStatus.pure);
    });

    test(
        "Default value of the 'result' variable must be \"(DetectorEntity(fakeProb: 0.00, realProb: 0.00, isSupportedLanguage: true)\" at start",
        () {
      expect(
        detectorCubit.state.result,
        const DetectorEntity(fakeProb: 0, realProb: 0, isSupportedLanguage: true),
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
        detectorCubit.state.copyWith(status: FormzStatus.submissionInProgress, failure: null),
        detectorCubit.state.copyWith(
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
        detectorCubit.state.copyWith(
          status: FormzStatus.submissionInProgress,
          failure: null,
          result: const DetectorEntity(
            realProb: 0,
            fakeProb: 0,
            isSupportedLanguage: true,
          ),
        ),
        detectorCubit.state.copyWith(
          status: FormzStatus.submissionSuccess,
          failure: null,
          result: mockDetectorEntity,
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
        detectorCubit.state.copyWith(userInput: invalidInputForm, status: Formz.validate([invalidInputForm])),
      ],
    );

    blocTest<DetectorCubit, DetectorState>(
      ' It should emit a userInput and FormzStatus.valid when input is not empty',
      build: () => detectorCubit,
      act: (bloc) => bloc.textChanged(text: validUserInput),
      expect: () => [
        detectorCubit.state.copyWith(userInput: validInputForm, status: Formz.validate([validInputForm])),
      ],
    );
  });

  group('DetectorCubit.clearTextPressed()', () {
    blocTest<DetectorCubit, DetectorState>(
      'It should emit a new DetectorState()',
      build: () => detectorCubit,
      act: (bloc) => bloc.clearTextPressed(),
      expect: () => [
        DetectorState.initial(),
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
        detectorCubit.state.copyWith(
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
        detectorCubit.state.copyWith(
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
        detectorCubit.state.copyWith(
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
        detectorCubit.state.copyWith(
          userInput: validInputForm,
          status: FormzStatus.valid,
        ),
      ],
    );
  });
}
