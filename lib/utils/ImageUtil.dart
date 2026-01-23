import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NetworkImageWithHeaders extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const NetworkImageWithHeaders({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  _NetworkImageWithHeadersState createState() =>
      _NetworkImageWithHeadersState();
}

class _NetworkImageWithHeadersState extends State<NetworkImageWithHeaders> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final response = await http.get(
        Uri.parse(widget.url),
        // headers: {
        //   "accept":
        //       "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        //   "accept-language": "zh,zh-TW;q=0.9,zh-CN;q=0.8",
        //   "cache-control": "max-age=0",
        //   "if-modified-since": "Fri, 16 Jan 2026 08:22:59 GMT",
        //   "if-none-match": "5n/oAkS5ziMrAQz2oxZ6ow==",
        //   "priority": "u=0, i",
        //   "sec-ch-ua":
        //       "\"Microsoft Edge\";v=\"143\", \"Chromium\";v=\"143\", \"Not A(Brand\";v=\"24\"",
        //   "sec-ch-ua-mobile": "?0",
        //   "sec-ch-ua-platform": "Windows",
        //   "sec-fetch-dest": "document",
        //   "sec-fetch-mode": "navigate",
        //   "sec-fetch-site": "none",
        //   "sec-fetch-user": "?1",
        //   "upgrade-insecure-requests": "1",
        //   "user-agent":
        //       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0",
        // },
      );

      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load image: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      );
    }

    return Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.cover,
    );
  }
}
