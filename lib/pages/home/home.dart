import 'package:bilibili_audio_downloader/models/Video.dart';
import 'package:bilibili_audio_downloader/pages/history/history_controller.dart';
import 'package:bilibili_audio_downloader/theme/brand.dart';
import 'package:bilibili_audio_downloader/utils/ToastUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // 获取控制器实例
  final HistoryController historyController = Get.find<HistoryController>();
  final inputController = TextEditingController();

  /// 下载音频
  void _downloadAudio(BuildContext context) async {
    // 检查输入是否为空
    if (inputController.text.isEmpty) {
      ToastUtil.showText("请输入BV号");
      return;
    }
    if (!inputController.text.startsWith("BV")) {
      ToastUtil.showText("请输入正确的BV号");
      return;
    }
    // _showDownloadSuccessDialog(context);
    historyController.download(inputController.text);
    inputController.clear();
  }

  /// 搜索框
  Widget _buildSearch(brand, context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                FIcons.music,
              ),
              const Text(
                "音频提取",
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: brand?.shadowColor,
                  offset: const Offset(0, 0.5),
                  blurRadius: 0.1,
                ),
              ],
            ),
            child: FTextField(
              control: .managed(controller: inputController),
              style: (style) => style.copyWith(
                fillColor: brand?.inputBackGroundColor,
                filled: true,
              ),
              suffixBuilder: (context, style, state) => IconButton(
                icon: Icon(FIcons.copy, color: brand?.iconColor),
                onPressed: () async {
                  // 粘贴到输入框
                  inputController.text = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
                },
              ),
              hint: '请输入BV号',
              clearable: (value) => value.text.isNotEmpty,
            ),
          ),
          FButton(
            style: FButtonStyle.primary(),
            prefix: const Icon(FIcons.download),
            mainAxisSize: MainAxisSize.max,
            onPress: () => _downloadAudio(context),
            shortcuts: {
              SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            },
            child: const Text('解析音频'),
          ),
        ],
      ),
    );
  }

  /// 最近解析列表
  Widget _buildRecent(BrandColor brand) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8.0,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(FIcons.rotateCcw, fontWeight: FontWeight.bold),
                const Text(
                  "最近解析",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),

          ],
        ),
        const SizedBox(height: 16.0),
        Obx(
          () => Column(
            spacing: 8,
            children: historyController.historyList
                .take(5)
                .map((video) => _buildRecentItem(brand, video))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentItem(BrandColor brand, Video video) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: brand.containerColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: brand.shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text("UP主: ${video.author}", style: TextStyle(fontSize: 14.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(video.duration, style: TextStyle(fontSize: 14.0)),
                    FButton(
                      style: FButtonStyle.ghost(
                        (style) => style.copyWith(
                          contentStyle: (style) => style.copyWith(
                            padding: EdgeInsets.all(0),
                            textStyle: FWidgetStateMap<TextStyle>({
                              WidgetState.any: TextStyle(fontSize: 14.0),
                            }),
                          ),
                        ),
                      ),
                      onPress: () => historyController.download(video.bvid),
                      child: Text('重新解析', style: TextStyle(color: brand.textColor),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FThemeBuildContext(context).theme;
    final brand = theme.extension<BrandColor>();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearch(brand, context),
          const SizedBox(height: 16.0),
          _buildRecent(brand),
        ],
      ),
    );
  }
}
