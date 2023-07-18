import 'package:gpt_detector/feature/splash/data/data_sources/local/splash_local_data_source.dart';
import 'package:gpt_detector/feature/splash/domain/repositories/splash_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SplashRepository)
final class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl({required SplashLocalDataSource splashLocalDataSource})
      : _splashLocalDataSource = splashLocalDataSource;

  final SplashLocalDataSource _splashLocalDataSource;
  @override
  bool? checkIsOnboardingCompleted() {
    return _splashLocalDataSource.checkIsOnboardingCompleted();
  }
}
