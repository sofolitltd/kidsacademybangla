import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

/// Google Play in-app updates (Android only).
///
/// - Normal updates are "flexible": downloaded in the background, then the
///   child/parent taps "রিস্টার্ট" in a snackbar to install.
/// - Updates marked high priority (4-5 in Play Console) are "immediate" and
///   block the app until installed.
/// Only works for builds installed from Google Play (e.g. internal testing).
class UpdateService {
  UpdateService._();

  static bool _checkedThisSession = false;
  static StreamSubscription<InstallStatus>? _installSub;

  static Future<void> checkForUpdate(BuildContext context) async {
    if (!Platform.isAndroid || _checkedThisSession) return;
    _checkedThisSession = true;

    try {
      final info = await InAppUpdate.checkForUpdate();

      // An immediate update was started earlier but not finished: resume it.
      if (info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      if (info.updatePriority >= 4 && info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (info.flexibleUpdateAllowed) {
        final result = await InAppUpdate.startFlexibleUpdate();
        if (result == AppUpdateResult.success && context.mounted) {
          _listenForDownload(context);
        }
      }
    } catch (e) {
      // Not installed from Play, no network, etc. Never bother the user.
      debugPrint('In-app update check skipped: $e');
    }
  }

  static void _listenForDownload(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    _installSub?.cancel();
    _installSub = InAppUpdate.installUpdateListener.listen((status) {
      if (status == InstallStatus.downloaded) {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(days: 1),
            behavior: SnackBarBehavior.floating,
            content: const Text('নতুন আপডেট ডাউনলোড হয়েছে!'),
            action: SnackBarAction(
              label: 'রিস্টার্ট',
              onPressed: InAppUpdate.completeFlexibleUpdate,
            ),
          ),
        );
        _installSub?.cancel();
      }
    });
  }
}
