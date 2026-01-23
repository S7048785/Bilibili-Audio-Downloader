import 'package:bilibili_audio_downloader/theme/brand.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = FThemeBuildContext(context).theme;
    final brand = theme.extension<BrandColor>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: brand.color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 26.0,
        ),
      ),
    );
  }
}
