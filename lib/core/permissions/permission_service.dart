import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionStatus;

part 'permission_service.g.dart';

@Riverpod(keepAlive: true)
PermissionService permissionService(PermissionServiceRef ref) =>
    const PermissionService();

class PermissionService {
  const PermissionService();

  /// Request [permission] and return the resulting status.
  Future<PermissionStatus> request(Permission permission) =>
      permission.request();

  /// Check the current status without triggering a system dialog.
  Future<PermissionStatus> check(Permission permission) =>
      permission.status;

  /// Returns `true` if the permission is granted.
  Future<bool> isGranted(Permission permission) async =>
      (await permission.status).isGranted;

  /// Opens the app settings page so the user can manually grant a permission
  /// that was permanently denied.
  Future<bool> openSettings() => openAppSettings();
}
