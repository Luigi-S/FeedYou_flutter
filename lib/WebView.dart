import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Assets.dart';

class MyWebView extends StatefulWidget {
  MyWebView({Key? key,
    required this.link,
    required this.category,
    required this.source}) : super(key: key);
  final String link;
  final String category;
  final String source;

  @override
  MyWebViewState createState() => MyWebViewState(this.link, this.category, this.source);
}

class MyWebViewState extends State<MyWebView> {
  MyWebViewState(String this.newsLink, String this.category, String this.source);
  String newsLink;
  String category;
  String source;


  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.teal),
        centerTitle: true,
        title:const Text(
              "Feed You",
              style: TextStyle(
                  fontFamily: 'RockSalt',
                  color: Colors.teal,
                  fontSize: 16.0
              )
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.block_flipped),
            onPressed: () {
                _block(source);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _share(newsLink);
            },
          ),
        ],
      ),

      body: WebView(
        initialUrl: newsLink,
      )
    );
  }


  Future<void> _block(String source) async {
    final prefs = await SharedPreferences.getInstance();
    String stringBlocked = prefs.getString('blockedLinks') ?? '';
    List<dynamic> blocked = [];
    if (stringBlocked != '') {
      blocked = jsonDecode(stringBlocked);
    }
    blocked.add(source);
    prefs.remove("blockedLinks");
    prefs.setString("blockedLinks", jsonEncode(blocked));
    final blockSnack = const SnackBar(content: Text(
        'Selected Source blocked successfully, you can view your blocked Sources in the menu'));
    ScaffoldMessenger.of(context).showSnackBar(blockSnack);
  }

  _share(String link){
    Share.share('Shared with FeedYou: $link');
  }

}