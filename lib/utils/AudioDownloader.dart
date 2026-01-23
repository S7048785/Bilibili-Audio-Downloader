/// 音频下载器

import "dart:io";

import "package:bilibili_audio_downloader/models/Video.dart";
// import "package:bilibili_audio_downloader/utils/FileUtil.dart";
import "package:http/http.dart" as http;

import "FileUtil.dart";
import "ToastUtil.dart";

class AudioDownloader {

  /// 获取音频
  ///
  /// [bvid] 视频BV号或URL
  ///
  /// 返回音频标题
  static Future<Video> getAudio(String bvid) async {
    String url = "";
    if (bvid.startsWith("BV")) {
      url = "https://www.bilibili.com/video/$bvid";
    }
    final headers = {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0",
      "Referer": "https://www.bilibili.com/",
    };

    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) {
      throw Exception("请求失败: ${response.statusCode}");
    }
    final text = response.body;

    final (audioUrl, title, author, timelength) = reText(text);
    if (audioUrl == "") {
      print("未找到音频链接，解析失败，停止下载");
    }

    var filename = "${title}";
    // 清理不合法的文件名
    filename = filename.replaceAll(RegExp(r'[\\/:*?"<>|]'), '');

    // 下载音频
    response = await http.get(Uri.parse(audioUrl), headers: headers);
    if (response.statusCode == 200) {
      // 写入文件
      final filePath = await FileUtil.saveAudio(response.bodyBytes, filename);
      ToastUtil.showText("下载成功, 保存路径: \n$filePath");
    } else {
      print("Failed to download audio, status code: ${response.statusCode}");
    }
    return Video(
      author: author,
      bvid: bvid,
      duration: timelength,
      title: title,
    );
  }

  /// 解析数据
  /// (audioUrl, title, author, timelength)
  static (String, String, String, String) reText(String text) {
    var re = RegExp(r"<h1 .*?>(.*?)</h1>");
    final titleMatch = re.firstMatch(text);

    // 获取标题
    String title = "audio";
    if (titleMatch != null && titleMatch.groupCount > 0) {
      // 提取标题文本并移除首尾空格
      title = titleMatch.group(1)!.trim();
    }
    // 获取音频链接
    String audioUrl = "";
    re = RegExp(r'"base_url"\s*:\s*"(.*?)"');
    re.allMatches(text).forEach((match) {
      if (match.group(0)!.length < 2) {
        return;
      }
      if (match.group(1)!.contains("1-30280")) {
        audioUrl = match.group(1)!;
        return;
      }
    });
    // 获取视频时长
    String timelength = "";
    re = RegExp(r'"timelength":(.*?),');

    final durationMatch = re.firstMatch(text);
    if (durationMatch != null && durationMatch.groupCount > 0) {
      final duration = durationMatch.group(1)!;
      timelength = formatMilliseconds(int.parse(duration));
    }

    // 获取作者
    re = RegExp(
      r'<meta data-vue-meta="true" itemprop="author" name="author" content="(.*?)">',
    );
    final authorMatch = re.firstMatch(text);
    String author = "";
    if (authorMatch != null && authorMatch.groupCount > 0) {
      author = authorMatch.group(1)!;
    }

    print("音频链接: $audioUrl");
    print("标题: $title");
    print("作者: $author");
    print("时长: $timelength");
    return (audioUrl, title, author, timelength);
  }

  // 格式化毫秒为分钟:秒数
  static String formatMilliseconds(int milliseconds) {
    // 确保输入非负
    final ms = milliseconds < 0 ? 0 : milliseconds;

    final totalSeconds = ms ~/ 1000; // 总秒数（向下取整）
    final minutes = totalSeconds ~/ 60; // 分钟数
    final seconds = totalSeconds % 60; // 剩余秒数

    // 格式化为两位数：不足两位前面补0
    final minuteStr = minutes.toString().padLeft(2, '0');
    final secondStr = seconds.toString().padLeft(2, '0');

    return '$minuteStr:$secondStr';
  }
}

void main() {
  // await AudioDownloader.getAudio("BV1pf421S7wv");
  // print("asd");
  // 读取文件
  // 同步读取 - 阻塞执行
  File file = File('test.html');
  String content = file.readAsStringSync();
  // print(content.substring(0, 100));
  final (audioUrl, title, author, timelength) = AudioDownloader.reText(content);
  print(audioUrl);
  print(title);
  print(author);
  print(timelength);
}
