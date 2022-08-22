import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleFeedView extends StatefulWidget{
  final Map<String, List> feeds;
  final String singleFeed;
  const SingleFeedView({super.key, required this.feeds, required this.singleFeed});

  @override
  State<SingleFeedView> createState() => _SingleFeedViewState(feeds, singleFeed);
}

class _SingleFeedViewState extends State<SingleFeedView>{
  final Map<String, List> feeds;
  String singleFeed;
  _SingleFeedViewState(this.feeds, this.singleFeed);

  _setSingleFeed(String feed){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>
          SingleFeedView(feeds: feeds, singleFeed: feed)),
    );
  }

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
              fontSize: 16.0
            ),
          ),
          actions: [
            TextButton(
              child: const Text("RESET", style: TextStyle(color: Colors.teal),),
              onPressed: _reset,
            ),
          ],
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
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: feeds.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Text(feeds.keys.elementAt(index),
                        style: const TextStyle(color: Colors.teal),),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: feeds[feeds.keys.elementAt(index)]!.length,
                          itemBuilder: (BuildContext context1, int index1) {
                            return FeedLine(
                              link: feeds[feeds.keys.elementAt(index)]![index1],
                              singleFeed: singleFeed,
                              parent: this
                            );
                          }
                        )
                      ]);
                    });
          }
        ),
      )
    );
  }

  Future<void> _reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("feedLink");
    _setSingleFeed('');
  }
}


class FeedLine extends StatefulWidget{
  final String link;
  final String singleFeed;
  final _SingleFeedViewState parent;
  const FeedLine({super.key, required this.link, required this.singleFeed, required this.parent});

  @override
  State<FeedLine> createState() => _FeedLineState(link, singleFeed, parent);
}

class _FeedLineState extends State<FeedLine>{
  final String link;
  String singleFeed;
  final _SingleFeedViewState parent;
  _FeedLineState(this.link, this.singleFeed, this.parent);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black54;
    if(singleFeed == link){
      color= Colors.teal;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(24,4,4,4),
      child: Row(
          children: [
            Expanded(
                flex: 8,
                child: Text(link, style: TextStyle(color: color))
            ),
            Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: (){
                    _toggleSingleFeed(parent);
                  },
                  child: const Icon(Icons.add_box_rounded, color: Colors.teal,)
                )
            )
          ]
      ),
    );
  }

  _toggleSingleFeed(_SingleFeedViewState parent) async {
    final prefs = await SharedPreferences.getInstance();
    if(singleFeed == link){
      prefs.remove("feedLink");
      setState(() {
        singleFeed = '';
      });
    }else{
      prefs.remove("feedLink");
      prefs.setString("feedLink", link);
      setState(() {
        singleFeed = link;
      });
    }
    parent._setSingleFeed(singleFeed);
  }
}