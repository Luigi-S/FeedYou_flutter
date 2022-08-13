
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedSourceView extends StatefulWidget{
  final Map<String, List> feeds;
  final List blocked;
  const BlockedSourceView({super.key, required this.feeds, required this.blocked});

  @override
  State<BlockedSourceView> createState() => _BlockedSourceViewState(feeds, blocked);
}

class _BlockedSourceViewState extends State<BlockedSourceView>{
  final Map<String, List> feeds;
  final List blocked;
  _BlockedSourceViewState(this.feeds, this.blocked);

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
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: DraggableScrollableSheet(
              minChildSize: 0,
              maxChildSize: 1,
              initialChildSize: 1,
              builder: (context, scrollController) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: feeds.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Text(feeds.keys.elementAt(index),
                            style: const TextStyle(color: Colors.teal),),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: feeds[feeds.keys.elementAt(index)]!.length,
                            itemBuilder: (BuildContext context1, int index1) {
                              return SourceLine(
                                  link: feeds[feeds.keys.elementAt(
                                    index)]![index1], blocked: blocked
                              );
                            },
                          )
                        ],
                      );
                    }
                );
              }
          )
        )
    );
  }
}

class SourceLine extends StatefulWidget{
  final String link;
  final List blocked;
  const SourceLine({super.key, required this.link, required this.blocked});

  @override
  State<SourceLine> createState() => _SourceLineState(link, blocked);
}

class _SourceLineState extends State<SourceLine>{
  final String link;
  List blocked;
  _SourceLineState(this.link, this.blocked);
  
  @override
  Widget build(BuildContext context) {
    Color color = Colors.black54;
    if(blocked.contains(link)){
      color= Colors.red;
    }
    return Padding(
     padding: const EdgeInsets.fromLTRB(24,4,4,4),
     child: Row(
         children: [
           Container(
             width: 300,
             child: Text(link, style: TextStyle(color: color))
           ),
           TextButton(
               onPressed: _block,
               child: const Icon(Icons.block_flipped, color: Colors.teal, )
           )
         ]
     ),
    );
  }

  _block() async {
    final prefs = await SharedPreferences.getInstance();

    if(blocked.contains(link)){
      print("SBLOCCANDO");
      blocked.remove(link);
    }else{
      print("BLOCCANDO");
      blocked.add(link);
    }
    prefs.remove("blockedLinks");
    prefs.setString("blockedLinks", jsonEncode(blocked));
    setState(() {
      blocked = blocked;
    });
  }
}
