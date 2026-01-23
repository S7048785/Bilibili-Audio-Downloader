import 'dart:convert';

import 'package:bilibili_audio_downloader/models/Video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryStore {

  static Future<List<Video>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getString('history');

    if (jsonList != null) {
      return (jsonDecode(jsonList) as List)
          .map((video) => Video.fromJson(video))
          .toList();
    } else {
      return [];
    }
  }

  static Future<void> set(List<Video> list) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonStr = jsonEncode(
      list.map((video) => video.toJson()).toList(),
    );
    await prefs.setString('history', jsonStr);
  }

}
