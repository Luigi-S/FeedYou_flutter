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
    _updatePref();

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

  Future<void> _updatePref() async {
    sleep(const Duration(seconds:20));
    final prefs = await SharedPreferences.getInstance();
    String stringTopics = prefs.getString('prefTopics') ?? '';
    String lang = prefs.getString('lang') ?? '';
    List<double> preferences = jsonDecode(stringTopics);
    var cats = Assets().topics(lang);
    int cat = cats.indexOf(category);
    for (int i =0; i<preferences.length;i++){
      if(i==cat){
        preferences[i] = (preferences[i]+0.01)/1.01;
      }else{
        preferences[i] = preferences[i]/1.01;
      }
    }
    prefs.clear();
    await prefs.setString('prefTopics', preferences.toString());
    DatabaseReference? ref = FirebaseAuth.instance.currentUser?.uid != null ?
      FirebaseDatabase.instance.ref("users/${FirebaseAuth.instance.currentUser!.uid}") :
      null;
    if(ref != null) {
      await ref.set({
      "lang": lang,
      "topics": preferences.toString(),
      });
    }
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
  }

  _share(String link){
    Share.share('Shared with FeedYou: $link');
  }

}