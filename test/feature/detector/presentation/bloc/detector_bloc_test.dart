import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_detector/core/enums/page_state.dart';
import 'package:gpt_detector/core/failures/failure.dart';
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
    test("Initial value of the 'pageState' variable must be 'PageState.initial' at start", () {
      expect(detectorBloc.state.pageState, PageState.initial);
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
      'DetectorEvent.detectionRequested() event test case: It should emit PageState.failure when Left type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(inputText)).thenAnswer(
          (_) async => const Left(Failure.networkFailure()),
        );
      },
      build: () => detectorBloc,
      act: (bloc) => bloc.add(DetectorEvent.detectionRequested(textInput: inputText)),
      expect: () => [
        DetectorState(pageState: PageState.loading),
        DetectorState(
          pageState: PageState.failure,
          failure: const Failure.networkFailure(),
        ),
      ],
    );

    blocTest<DetectorBloc, DetectorState>(
      'DetectorEvent.detectionRequested() event test case: It should emit PageState.loaded and a DetectorEntity instance when Right type returned from mockDetectUseCase',
      setUp: () {
        when(() => mockDetectUseCase(inputText)).thenAnswer(
          (_) async => Right(mockDetectorEntity),
        );
      },
      build: () => detectorBloc,
      act: (bloc) => bloc.add(DetectorEvent.detectionRequested(textInput: inputText)),
      expect: () => [
        DetectorState(pageState: PageState.loading),
        DetectorState(
          result: mockDetectorEntity,
          pageState: PageState.loaded,
        ),
      ],
    );
  });

  blocTest<DetectorBloc, DetectorState>(
    'DetectorEvent.clearTextPressed() event test case: It should emit a new state with PageState.initial value',
    build: () => detectorBloc,
    act: (bloc) => bloc.add(const DetectorEvent.clearTextPressed()),
    expect: () => [
      DetectorState(pageState: PageState.initial),
    ],
  );
}
