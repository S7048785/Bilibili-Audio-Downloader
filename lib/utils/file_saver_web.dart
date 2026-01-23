import 'dart:html';
import 'dart:typed_data';

Future<String?> saveToWeb(Uint8List data, String fileName) async {
  try {
    final blob = Blob([data]);
    final url = Url.createObjectUrl(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';
    document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    Url.revokeObjectUrl(url);
    return fileName;
  } catch (e) {
    print('Error saving file on Web: $e');
    return null;
  }
}
