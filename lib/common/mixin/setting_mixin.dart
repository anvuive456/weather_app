import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/setting/screen/setting_dialog.dart';
import '../../resources/color.dart';
import '../widget/app_button.dart';

mixin AppSettingMixin<S extends ConsumerStatefulWidget> on ConsumerState<S> {
  Widget get settingIcon => AppButton(
      onTap: openSettings,
      child: const Icon(
        Icons.settings,
        color: kWhiteColor,
      ));

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
