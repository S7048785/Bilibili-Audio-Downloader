import 'package:bilibili_audio_downloader/models/Video.dart';
import 'package:bilibili_audio_downloader/stores/history_store.dart';
import 'package:bilibili_audio_downloader/utils/AudioDownloader.dart';
import 'package:bilibili_audio_downloader/utils/ToastUtil.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final RxList<Video> _historyList = <Video>[].obs;
  List<Video> get historyList => _historyList;

  Future<void> loadHistory() async {
    _historyList.addAll(await HistoryStore.get());
  }

  Future<void> download(String bvid) async {
    ToastUtil.showText("下载中: $bvid");
    try {
      final video = await AudioDownloader.getAudio(bvid);
      addHistory(video);
    } catch (e) {
      ToastUtil.showText("下载失败: \n${e.toString()}");
      throw Exception(e.toString());
    }
  }

  Future<void> addHistory(Video video) async {
    // 检查是否已存在相同视频
    for (var v in _historyList) {
      if (v.bvid == video.bvid) {
        // 如果已存在，则移除旧的记录
        _historyList.remove(video);
      }
    }
    // 限制历史记录数量
    if (_historyList.length > 20) {
      _historyList.removeAt(0);
    }
    _historyList.add(video);
    await HistoryStore.set(_historyList.toList());
  }

  Future<void> removeHistory(Video video)async {
    _historyList.remove(video);
    await HistoryStore.set(_historyList.toList());
  }



  Future<void> clear() async {
    _historyList.clear();
    await HistoryStore.set([]);
  }

  @override
  void onInit() {
    super.onInit();
    // 从本地存储加载历史记录
    loadHistory();
  }
}
