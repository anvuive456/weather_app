import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/setting/presentation/screens/setting_dialog.dart';
import '../../resources/color.dart';

mixin AppSettingMixin<S extends ConsumerStatefulWidget> on ConsumerState<S> {
  Widget get settingIcon => GestureDetector(
        onTap: openSettings,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: const Icon(Icons.settings_outlined,
              color: Colors.white, size: 20),
        ),
      );

  void openSettings() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SettingDialog();
      },
    );
  }
}
