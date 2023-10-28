import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../resources/color.dart';

class AppToast {
  static void showSuccess(String message) {
    BotToast.showSimpleNotification(
      title: message,
      duration: const Duration(seconds: 1),
      hideCloseButton: true,
      backgroundColor: AppColors.primary,
      borderRadius: 20.0,
    );
  }

  static void showWarning(String message) {
    BotToast.showSimpleNotification(
      title: message,
      duration: const Duration(seconds: 1),
      hideCloseButton: false,
      backgroundColor: AppColors.darkGrey,
      borderRadius: 10.0,
      align: Alignment.bottomCenter,
    );
  }

  static void showError(String message) {
    BotToast.showSimpleNotification(
      title: message,
      duration: const Duration(seconds: 2),
      hideCloseButton: false,
      backgroundColor: AppColors.red,
      borderRadius: 10.0,
      titleStyle: const TextStyle(color: AppColors.white,fontSize: 14),
      align: Alignment.bottomCenter,
    );
  }

  static CancelFunc? _loading;

  static void showLoading() {
    _loading = BotToast.showLoading();
  }

  static hideLoading() {
    _loading?.call();
    _loading = null;
    BotToast.closeAllLoading();
  }
}
