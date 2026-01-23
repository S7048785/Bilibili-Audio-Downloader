import 'package:bilibili_audio_downloader/theme/theme.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final FThemeData lightTheme = slateLight; // 实例化一次
  final FThemeData darkTheme = slateDark; // 实例化一次

  late final _theme = lightTheme.obs;

  FThemeData get theme => _theme.value;

  void toggleTheme() {
    final isLight = identical(_theme.value, lightTheme); // 引用比较更稳妥
    print('isLight: $isLight');
    _theme.value = isLight ? darkTheme : lightTheme;
  }

  bool get isDark => identical(_theme.value, darkTheme);
}
