import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:task11/homepage.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewPage extends StatefulWidget {
  String websiteUrl;
  WebViewPage({Key? key, required this.websiteUrl}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable, avoid_print
    print(widget.websiteUrl);
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('webpage'),
      ),
      body: Center(
        child: WebView(
          initialUrl: widget.websiteUrl,
        ),
      ),
    );
  }
}
