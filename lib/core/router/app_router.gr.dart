// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../../feature/detector/presentation/view/detect_view.dart' as _i2;
import '../../feature/onboarding/presentation/view/onboarding_view.dart' as _i1;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    OnboardingRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.OnboardingView(),
      );
    },
    DetectRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.DetectView(),
      );
    },
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(
          OnboardingRoute.name,
          path: '/onboarding-view',
        ),
        _i3.RouteConfig(
          DetectRoute.name,
          path: '/detect-view',
        ),
        _i3.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.OnboardingView]
class OnboardingRoute extends _i3.PageRouteInfo<void> {
  const OnboardingRoute()
      : super(
          OnboardingRoute.name,
          path: '/onboarding-view',
        );

  static const String name = 'OnboardingRoute';
}

/// generated route for
/// [_i2.DetectView]
class DetectRoute extends _i3.PageRouteInfo<void> {
  const DetectRoute()
      : super(
          DetectRoute.name,
          path: '/detect-view',
        );

  static const String name = 'DetectRoute';
}
