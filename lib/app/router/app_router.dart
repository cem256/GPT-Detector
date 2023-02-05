import 'package:auto_route/auto_route.dart';
import 'package:gpt_detector/feature/detector/presentation/view/detect_view.dart';
import 'package:gpt_detector/feature/onboarding/presentation/view/onboarding_view.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'View,Route',
  routes: [
    AutoRoute(page: OnboardingView),
    AutoRoute(page: DetectView),
    RedirectRoute(path: '*', redirectTo: ''),
  ],
)
class $AppRouter {}
