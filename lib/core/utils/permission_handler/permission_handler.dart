import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionHandlerUtils {
  Future<bool> hasGalleryPermission();
  Future<bool> hasCameraPermission();
  Future<void> requestGalleryPermission();
  Future<void> requestCameraPermission();
}

class PermissionHandlerUtilsImpl implements PermissionHandlerUtils {
  @override
  Future<bool> hasGalleryPermission() async {
    late final PermissionStatus status;
    if (Platform.isAndroid) {
      final permission = await _getAndroidGalleryPermissionType();
      status = await permission.status;
    } else if (Platform.isIOS) {
      status = await Permission.photos.status;
    }
    return status.isGranted;
  }

  @override
  Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  @override
  Future<void> requestGalleryPermission() async {
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

  @override
  Future<void> requestCameraPermission() async {
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
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    late final Permission permission;
    if (deviceInfo.version.sdkInt <= 32) {
      permission = Permission.storage;
    } else {
      permission = Permission.photos;
    }
    return permission;
  }
}
