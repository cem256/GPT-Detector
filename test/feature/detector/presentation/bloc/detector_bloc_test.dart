import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
import 'package:gpt_detector/feature/detector/presentation/bloc/detector_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectUseCase extends Mock implements DetectUseCase {}

class MockDetectorEntity extends Mock implements DetectorEntity {}

void main() {
  late DetectorBloc detectorBloc;
  late MockDetectUseCase mockDetectUseCase;
  late MockDetectorEntity mockDetectorEntity;
  late String inputText;

  setUp(() {
    mockDetectUseCase = MockDetectUseCase();
    detectorBloc = DetectorBloc(detectUseCase: mockDetectUseCase);
    mockDetectorEntity = MockDetectorEntity();
    inputText = 'Test Input';
  });
  group('Detector Bloc Tests', () {
    test("Initial value of the 'detectorStatus' variable must be 'DetectorStatus.initial' at start", () {
      expect(detectorBloc.state.detectorStatus, DetectorStatus.initial);
    });

    test(
        "Default value of the 'result' variable must be \"(DetectorEntity(fakeProb: 0.00, realProb: 0.00, allTokens: 0)\" at start",
        () {
      expect(
        detectorBloc.state.result,
        const DetectorEntity(fakeProb: 0, realProb: 0, allTokens: 0),
      );
    });

    test("Default value of the 'isValidInput' variable must be 'true' at start", () {
      expect(detectorBloc.state.isValidInput, true);
    });

    blocTest<DetectorBloc, DetectorState>(
      'DetectorEvent.detectionRequested() event test case: It should emit DetectorStatus.failure when Left type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(inputText)).thenAnswer(
          (_) async => const Left(Failure.networkFailure()),
        );
      },
      build: () => detectorBloc,
      act: (bloc) => bloc.add(DetectorEvent.detectionRequested(textInput: inputText)),
      expect: () => [
        DetectorState(detectorStatus: DetectorStatus.loading),
        DetectorState(
          detectorStatus: DetectorStatus.failure,
          failure: const Failure.networkFailure(),
        ),
      ],
    );

    blocTest<DetectorBloc, DetectorState>(
      'DetectorEvent.detectionRequested() event test case: It should emit DetectorStatus.loaded and a DetectorEntity instance when Right type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(inputText)).thenAnswer(
          (_) async => Right(mockDetectorEntity),
        );
      },
      build: () => detectorBloc,
      act: (bloc) => bloc.add(DetectorEvent.detectionRequested(textInput: inputText)),
      expect: () => [
        DetectorState(detectorStatus: DetectorStatus.loading),
        DetectorState(
          result: mockDetectorEntity,
          detectorStatus: DetectorStatus.success,
        ),
      ],
    );
  });

  blocTest<DetectorBloc, DetectorState>(
    'DetectorEvent.clearTextPressed() event test case: It should emit a new state with DetectorStatus.initial value',
    build: () => detectorBloc,
    act: (bloc) => bloc.add(const DetectorEvent.clearTextPressed()),
    expect: () => [
      DetectorState(detectorStatus: DetectorStatus.initial),
    ],
  );
}
