import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  MyWebView({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  MyWebViewState createState() => MyWebViewState(this.link);
}

class MyWebViewState extends State<MyWebView> {
  MyWebViewState(String this.newsLink);
  String newsLink;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return  WebView(
      initialUrl: newsLink,
    );
  }
}