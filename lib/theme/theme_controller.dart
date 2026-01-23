import 'package:bilibili_audio_downloader/theme/theme.dart';
import 'package:bilibili_audio_downloader/utils/ToastUtil.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final FThemeData lightTheme = slateLight; // 实例化一次
  final FThemeData darkTheme = slateDark; // 实例化一次

  late final _theme = lightTheme.obs;

  FThemeData get theme => _theme.value;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    var isDark = prefs.getBool("isDarkMode");

    if (isDark == null) {
      setThemeMode(false);
      isDark = false;
    }
    _theme.value = isDark ? darkTheme : lightTheme;
  }

  void toggleTheme() {
    final isLight = identical(_theme.value, lightTheme); // 引用比较更稳妥
    _theme.value = isLight ? darkTheme : lightTheme;
    setThemeMode(isLight);
  }

  Future<void> setThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  bool get isDark => identical(_theme.value, darkTheme);
}
