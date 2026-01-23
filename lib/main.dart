import 'package:bilibili_audio_downloader/pages/history/history_controller.dart';
import 'package:bilibili_audio_downloader/theme/brand.dart';
import 'package:bilibili_audio_downloader/theme_controller.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

import 'pages/history/history.dart';
import 'pages/home/home.dart';
import 'pages/settings.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    Get.put(HistoryController());
    final botToastBuilder = BotToastInit(); //1.调用BotToastInit

    return GetMaterialApp(
      builder: (_, child) {
        FAnimatedTheme(data: themeController.theme, child: child!);
        child = botToastBuilder(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      home: Obx(
        () =>
            FAnimatedTheme(data: themeController.theme, child: const Example()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}



class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final themeController = Get.find<ThemeController>();

  late final headers = [
    Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('首页', style: TextStyle(fontSize: 18)),
    ),
    Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('记录', style: TextStyle(fontSize: 18)),
    ),
    Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('设置', style: TextStyle(fontSize: 18)),
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final brand = BrandColor.getColor(context);
    return FScaffold(
      childPad: false,
      footer: FBottomNavigationBar(
        index: _index,
        onChange: (index) => setState(() => _index = index),
        style: (style) => style.copyWith(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: brand.containerColor, width: 1),
            ),
            color: brand.bottomNavigationBarColor,
          ),
        ),
        children: const [
          FBottomNavigationBarItem(icon: Icon(FIcons.house), label: Text('首页')),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.layoutGrid),
            label: Text('记录'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.settings),
            label: Text('设置'),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            headers[_index],
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IndexedStack(
                  index: _index,
                  children: [HomePage(), HistoryPage(), SettingsPage()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
