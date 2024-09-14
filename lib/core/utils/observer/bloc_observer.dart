import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_detector/core/utils/logger/logger_utils.dart';

final class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    this.logEvents = true,
    this.logChanges = true,
    this.logTransitions = true,
    this.logErrors = true,
    this.logCreated = true,
    this.logClosed = true,
  });

  final bool logEvents;
  final bool logChanges;
  final bool logTransitions;
  final bool logErrors;
  final bool logCreated;
  final bool logClosed;

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (logEvents) {
      LoggerUtils.instance.logInfo('${bloc.runtimeType} $event');
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (logChanges) {
      LoggerUtils.instance.logInfo('${bloc.runtimeType} $change');
    }
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    if (logTransitions) {
      LoggerUtils.instance.logInfo('${bloc.runtimeType} $transition');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (logErrors) {
      LoggerUtils.instance.logError('${bloc.runtimeType} $error');
    }
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (logClosed) {
      LoggerUtils.instance.logInfo('${bloc.runtimeType} closed');
    }
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (logCreated) {
      LoggerUtils.instance.logInfo('${bloc.runtimeType} created');
    }
  }
}
