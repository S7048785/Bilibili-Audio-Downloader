import 'dart:typed_data';

// 非 Web 平台的空实现（不会编译 dart:html）
Future<String?> saveToWeb(Uint8List data, String fileName) async {
  return null;
}
