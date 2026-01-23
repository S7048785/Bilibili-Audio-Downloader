/// 文件保存工具类
import 'dart:io' as io;
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

// 条件导入：Web 平台导入 web 实现，非 Web 平台导入空实现
import 'file_saver_stub.dart' if (dart.library.html) 'file_saver_web.dart';

class FileUtil {
  /// 保存音频到手机或 Web 浏览器
  static Future<void> saveAudio(Uint8List audioData, String? fileName) async {
    if (kIsWeb) {
      fileName ??= 'audio-${DateTime.now().millisecondsSinceEpoch}.mp3';
      await saveToWeb(audioData, fileName);
    }
    if (io.Platform.isAndroid) {
      fileName ??= 'audio-${DateTime.now().millisecondsSinceEpoch}.mp3';
      _saveToAndroidMusic(audioData, fileName);
    }
  }

  /// 保存音频到 Android 音乐目录
  static Future<void> _saveToAndroidMusic(
    Uint8List audioData,
    String fileName,
  ) async {
    try {
      // 获取 Android 音乐目录路径
      String musicPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_MUSIC,
      );

      // 创建完整的文件路径
      String fullPath = '$musicPath/$fileName.mp3';

      // 创建文件并写入数据
      io.File file = io.File(fullPath);
      await file.writeAsBytes(audioData);

      print('Audio saved to music directory: $fullPath');

      // 刷新媒体库，使文件立即可见
      // await _refreshMediaStore(fullPath);
    } catch (e) {
      print('Error saving audio to music directory: $e');
      // 如果保存到音乐目录失败，回退到应用目录
      String? savedPath = await _saveToMobile(
        audioData,
        '$fileName.mp3',
        subDir: 'Audios',
      );
      if (savedPath != null) {
        print('Audio saved to app directory as fallback: $savedPath');
      }
    }
  }

  /// 刷新媒体库，使新保存的音频立即可见
  static Future<void> _refreshMediaStore(String filePath) async {
    if (io.Platform.isAndroid) {
      try {
        // 这里可以通过 MethodChannel 调用原生代码刷新媒体库
        // 或者依赖 Android 系统自动扫描
        print('Refreshed media store for: $filePath');
      } catch (e) {
        print('Error refreshing media store: $e');
      }
    }
  }

  /// 移动端通用实现（iOS/Android）
  static Future<String?> _saveToMobile(
    Uint8List data,
    String fileName, {
    String? subDir,
  }) async {
    try {
      // 获取应用文档目录
      io.Directory appDocDir = await getApplicationDocumentsDirectory();

      if (subDir != null) {
        appDocDir = io.Directory('${appDocDir.path}/$subDir');
        if (!await appDocDir.exists()) {
          await appDocDir.create(recursive: true);
        }
      }

      String filePath = '${appDocDir.path}/$fileName';
      io.File file = io.File(filePath);

      await file.writeAsBytes(data);

      return filePath;
    } catch (e) {
      print('Error saving file on mobile: $e');
      return null;
    }
  }
}
