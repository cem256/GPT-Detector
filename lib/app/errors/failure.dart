import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.noInternetFailure() = _NoInternetFailure;
  const factory Failure.networkFailure() = _NetworkFailure;
  const factory Failure.noPermission() = _NoPermission;
  const factory Failure.ocrFailure() = _OCRFailure;
}
