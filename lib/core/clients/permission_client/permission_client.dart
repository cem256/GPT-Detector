import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionClient {
  Future<bool> hasCameraPermission();
  Future<bool> hasGalleryPermission();
}

@Injectable(as: PermissionClient)
class PermissionClientImpl implements PermissionClient {
  PermissionClientImpl({required DeviceInfoPlugin deviceInfoPlugin}) : _deviceInfoPlugin = deviceInfoPlugin;

  final DeviceInfoPlugin _deviceInfoPlugin;

  @override
  Future<bool> hasCameraPermission() async {
    final hasPermission = await _isCameraPermissionGranted();

    if (hasPermission) {
      return true;
    } else {
      await _requestCameraPermission();
      return false;
    }
  }

  @override
  Future<bool> hasGalleryPermission() async {
    final hasPermission = await _isGalleryPermissionGranted();
    if (hasPermission) {
      return true;
    } else {
      await _requestGalleryPermission();
      return false;
    }
  }

  Future<bool> _isGalleryPermissionGranted() async {
    late final PermissionStatus status;
    if (Platform.isAndroid) {
      final permission = await _getAndroidGalleryPermissionType();
      status = await permission.status;
    } else if (Platform.isIOS) {
      status = await Permission.photos.status;
    }
    return status.isGranted;
  }

  Future<bool> _isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<void> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final permission = await _getAndroidGalleryPermissionType();

      final before = await permission.shouldShowRequestRationale;
      final rs = await permission.request();
      final after = await permission.shouldShowRequestRationale;
      // If the user denies the permission twice, openAppSettings will be called
      if (!rs.isGranted && !before && !after) {
        await openAppSettings();
      }
    } else if (Platform.isIOS) {
      final result = await Permission.photos.status;

      if (result.isDenied) {
        await Permission.photos.request();
      } else if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  Future<void> _requestCameraPermission() async {
    if (Platform.isAndroid) {
      const permission = Permission.camera;

      final before = await permission.shouldShowRequestRationale;
      final rs = await permission.request();
      final after = await permission.shouldShowRequestRationale;

      // If the user denies the permission twice, openAppSettings will be called
      if (!rs.isGranted && !before && !after) {
        await openAppSettings();
      }
    } else if (Platform.isIOS) {
      final result = await Permission.camera.status;

      if (result.isDenied) {
        await Permission.camera.request();
      } else if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  /// Returns the type of the permission depending on the sdk version
  ///* Returns [Permission.storage] if device sdk version is <=32
  ///* Returns [Permission.photos] if device sdk version is >32
  Future<Permission> _getAndroidGalleryPermissionType() async {
    final deviceInfo = await _deviceInfoPlugin.androidInfo;
    late final Permission permission;
    if (deviceInfo.version.sdkInt <= 32) {
      permission = Permission.storage;
    } else {
      permission = Permission.photos;
    }
    return permission;
  }
}
