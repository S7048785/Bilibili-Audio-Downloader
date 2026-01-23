import 'package:bilibili_audio_downloader/models/Video.dart';
import 'package:bilibili_audio_downloader/theme/brand.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

import 'history_controller.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final historyController = Get.find<HistoryController>();

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
                      onPress: () {
                        historyController.download(video.bvid);
                      },
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "全部下载记录",
                    style: TextStyle(fontSize: 18.0),
                  ),

                  Text("${historyController.historyList.length}/20", style: TextStyle(fontSize: 14.0)),
                ],
              ),
              FButton(
                style: FButtonStyle.ghost(
                      (style) => style.copyWith(
                    contentStyle: (style) => style.copyWith(
                      textStyle: FWidgetStateMap<TextStyle>({
                        WidgetState.any: TextStyle(fontSize: 14.0),
                      }),
                    ),
                  ),
                ),
                mainAxisSize: MainAxisSize.min,
                onPress: () {
                  historyController.clear();
                },
                prefix: const Icon(FIcons.trash, color: Color(0xff9ca3af)),
                child: const Text('清空'),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Obx(() => ListView.separated(
            itemCount: historyController.historyList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 8.0), // 添加间距
            itemBuilder: (context, index) {
              final video = historyController.historyList[index];
              return _buildRecentItem(brand, video);
            },
          ))
        ],
      ),
    );
  }
}
