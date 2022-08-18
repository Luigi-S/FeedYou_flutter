
import 'dart:convert';

import 'package:feed_you_flutter/Account.dart';
import 'package:feed_you_flutter/BlockedSourceView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Assets.dart';
import 'Preferences.dart';
import 'SingleFeedView.dart';

class MenuView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.teal),
          title: const Text(
            "Feed You",
            style: TextStyle(
              fontFamily: 'RockSalt',
              color: Colors.teal,
              fontSize: 20.0
            )
          ),
        ),
        body:Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: TextButton(
                  onPressed:(){ _toBlockedSourceView(context);},
                  child: Row(
                    children: const [
                      Icon(Icons.block, color: Colors.teal,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text("Blocked Sources", style: TextStyle(color: Colors.teal),)
                      )
                    ],
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: TextButton(
                  onPressed:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreferencesView())
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.add_reaction, color: Colors.teal,),
                      Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text("Change Preferences", style: TextStyle(color: Colors.teal),)
                      )
                    ],
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: TextButton(
                  onPressed:(){ _toSingleFeedView(context);},
                  child: Row(
                    children: const [
                      Icon(Icons.add_card, color: Colors.teal,),
                      Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text("Single Feed Mode", style: TextStyle(color: Colors.teal),)
                      )
                    ],
                  ),
                )
            ),

            Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: TextButton(
                  onPressed:(){_toAccount(context);},
                  child: Row(
                    children: const [
                      Icon(Icons.manage_accounts_rounded, color: Colors.teal,),
                      Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text("Account", style: TextStyle(color: Colors.teal),)
                      )
                    ],
                  ),
                )
            ),


          ],
        )
    );
  }

  _toBlockedSourceView(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? lang = await prefs.getString("lang")!;
    String stringBlocked = prefs.getString('blockedLinks') ?? '';
    List<dynamic> blockedLinks = [];
    if (stringBlocked != '') {
      blockedLinks = jsonDecode(stringBlocked);
    }
    Map<String, List> feeds = Assets().feeds(lang)!;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          BlockedSourceView(feeds: feeds, blocked: blockedLinks)),
    );
  }

  _toSingleFeedView(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? lang = await prefs.getString("lang")!;
    String singleFeed = prefs.getString('feedLink') ?? '';
        Map<String, List> feeds = Assets().feeds(lang)!;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          SingleFeedView(feeds: feeds, singleFeed: singleFeed)),
    );
  }

  _toAccount(BuildContext context) async {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Account()),
    );


  }


}