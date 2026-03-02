import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/features/setting/presentation/providers/setting_provider.dart';
import 'package:weather_app/resources/color.dart';

class SettingDialog extends ConsumerStatefulWidget {
  const SettingDialog({super.key});

  @override
  ConsumerState<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends ConsumerState<SettingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currDegree = ref.watch(settingProvider.select((v) => v.degreeType));
    final currMeasure = ref.watch(settingProvider.select((v) => v.measureType));
    final currLang = ref.watch(settingProvider.select((v) => v.language));
    final notifier = ref.read(settingProvider.notifier);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        children: [
                          const Icon(Icons.tune_rounded,
                              size: 16, color: AppColors.accent),
                          const SizedBox(width: 8),
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close_rounded,
                                size: 18, color: Colors.white38),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Temperature
                      _ToggleRow(
                        icon: CupertinoIcons.thermometer,
                        label: 'Temperature',
                        options: const ['°C', '°F'],
                        selectedIndex:
                            currDegree == DegreeType.celsius ? 0 : 1,
                        onSelect: (i) => notifier
                            .changeDegreeType(DegreeType.values[i]),
                      ),
                      const SizedBox(height: 14),

                      // Wind / Distance
                      _ToggleRow(
                        icon: CupertinoIcons.speedometer,
                        label: 'Speed & Distance',
                        options: const ['km', 'mi'],
                        selectedIndex:
                            currMeasure == MeasureType.km ? 0 : 1,
                        onSelect: (i) => notifier
                            .changeMeasureType(MeasureType.values[i]),
                      ),
                      const SizedBox(height: 14),

                      // Language
                      _ToggleRow(
                        icon: CupertinoIcons.globe,
                        label: 'Language',
                        options: AppLanguage.values
                            .map((l) => l.title)
                            .toList(),
                        selectedIndex: AppLanguage.values.indexOf(currLang),
                        onSelect: (i) => notifier
                            .changeLanguage(AppLanguage.values[i]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Toggle row ────────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> options;
  final int selectedIndex;
  final void Function(int) onSelect;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.white54),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        _PillToggle(
          options: options,
          selectedIndex: selectedIndex,
          onSelect: onSelect,
        ),
      ],
    );
  }
}

// ── Pill toggle ───────────────────────────────────────────────────────────────

class _PillToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final void Function(int) onSelect;

  const _PillToggle({
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length; i++)
            GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: i == selectedIndex
                      ? AppColors.accent.withAlpha(200)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: i == selectedIndex
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withAlpha(60),
                            blurRadius: 8,
                          )
                        ]
                      : null,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: i == selectedIndex
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: i == selectedIndex
                        ? Colors.white
                        : Colors.white38,
                  ),
                  child: Text(options[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
