import 'package:bilibili_audio_downloader/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, ),
          child: Text(
            '外观',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Obx(
              () => _SettingsTile(
            title: '深色模式',
            subtitle: '切换浅色和深色主题',
            trailing: FSwitch(
                value: themeController.isDark,
                onChange: (value) => themeController.toggleTheme()
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(title, style: FThemeBuildContext(context).theme.typography.lg),
              if (subtitle != null) Text(subtitle!, style: FThemeBuildContext(context).theme.typography.sm),
            ],
          ),

        ?trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      ],
    );
  }
}
