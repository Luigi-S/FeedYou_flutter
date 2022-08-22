
import 'dart:convert';
import 'dart:math';

import 'package:favicon/favicon.dart' as favicon;
import 'package:feed_you_flutter/Assets.dart';
import 'package:feed_you_flutter/NewsData.dart';
import 'package:feed_you_flutter/Preferences.dart';
import 'package:feed_you_flutter/WebView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

import 'Menu.dart';

class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List _result = [];
  List _sources = [];
  bool _visibility = false;

  void _setList(list) {
    setState(() {
      _result = list;
    });
  }
  void _setSources(list) {
    setState(() {
      _sources = list;
    });
  }


  void fetchFeed()  async {
    print("=== CARICAMENTO NUOVE NEWS ===");
    final prefs = await SharedPreferences.getInstance();

    //lista da popolare con le notizie da far comparire
    List news = [];
    List sources = [];

    String singleFeed = prefs.getString('feedLink') ?? '';

    String stringTopics = prefs.getString('prefTopics') ?? '';
    String stringLang = prefs.getString('lang') ?? '';

    String stringBlocked = prefs.getString('blockedLinks') ?? '';
    List<dynamic> blockedLinks = [];
    if (stringBlocked != ''){
      blockedLinks = jsonDecode(stringBlocked);
    }

    List<String> topics = Assets().topics(stringLang);
    if (stringTopics != '' && stringLang != ''){
      List<dynamic> prefTopics = jsonDecode(stringTopics);
      List<double> bounds = [];
      bounds.add(prefTopics.first);
      for(int i = 1; i< prefTopics.length; i++){
        bounds.add(bounds[i-1] + prefTopics[i]);
      }
      //lista dei link ai feed di una lingua, divisi per topic
      Map<String, List> feeds = Map.of(Assets().feeds(stringLang)!);
      List newsByTopic = [];
      if(singleFeed!=''){
        for(String arg in feeds.keys){
          if(feeds[arg]!.contains(singleFeed)){
              feeds[arg] = <String>[singleFeed];
          }else{
            feeds[arg] = [];
          }
        }
      }

      for (String topic in feeds.keys){
        newsByTopic.add(<NewsData>[]);
        for (int i =0 ;i<feeds[topic]!.length; i++){
          if(blockedLinks.contains(feeds[topic]![i]) && singleFeed!=feeds[topic]![i]){
            break;
          }
          var url = Uri.parse(feeds[topic]![i]);
          try {
            http.Response response1 = await http.get(url);
            if (response1.statusCode == 200) {
              var decodedData = RssFeed.parse((const Utf8Decoder().convert(response1.bodyBytes)));
              List<RssItem> items = decodedData.items!;

              favicon.Icon? ico = await favicon.Favicon.getBest(items.first.link!);
              Image img = ico!= null ? Image.network(ico.url,height: 30,width: 30,fit: BoxFit.fill) :
              const Image(image: AssetImage('images/logo.png'),height: 30,width: 30,fit: BoxFit.fill);

              Color col = Assets().topicColor(int.parse(topic));
              sources.add(SourceData(feeds[topic]![i], img, topics[int.parse(topic)], col));

              for (RssItem item in items) {
                newsByTopic[int.parse(topic)].add(
                    NewsData(item.title!, item.link!, sources.length-1));
              }
            }
          } catch (e) {;}
        }
        newsByTopic[int.parse(topic)].shuffle();
      }
      if(singleFeed==''){
        for(int j =0; j<40; j++){
          double rand = Random().nextDouble();
          int i =0;
          while(i< bounds.length && rand>bounds[i]){i++;}
          if(newsByTopic[i].isNotEmpty) {
            news.add(newsByTopic[i].removeAt(0));
          }
        }
      }
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreferencesView()),
      );
      return;
    }
    _setSources(sources);
    _setList(news);
  }


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Image.asset(
            'images/logo.png',
            width: 100,
            height: 100,

          ),
            content: const Text('Are you sure you want to exit Feed You?',
              style: TextStyle(
                  fontFamily: 'Asap',
                  fontSize: 16,
                  color: Color(0xFF232323)
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    _hasPrefs();

    if (_result.isNotEmpty) {
      return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
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
              actions: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MenuView()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _visibility = !_visibility;
                    });
                  },
                ),
              ],

            ),

            body:RefreshIndicator(
                  onRefresh: () async {
                    return fetchFeed();
                  },
                  child: Column(
                    children:[
                      Visibility(
                        visible: _visibility,
                        child: Expanded(
                          flex: 1,
                          child:TextField(
                            onChanged: (value) => _filter(value),
                            decoration: const InputDecoration(
                              labelText: 'Search', suffixIcon: Icon(Icons.search)),
                          ),
                        )
                      ),
                      Expanded(
                      flex: 10,
                      //padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                      child:
                          DraggableScrollableSheet(
                          minChildSize: 0,
                          maxChildSize: 1,
                          initialChildSize: 1,
                          builder: (context, scrollController) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: _result.length,
                                itemBuilder: (context, index) {
                                  return ListTile(title: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            MyWebView(
                                                link: _result[index].link,
                                                source: _sources[_result[index]
                                                    .source].link,
                                                category: _sources[_result[index]
                                                    .source].category
                                            )),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(4.0),
                                      child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(children: <Widget>[
                                                  Align(
                                                      alignment: Alignment
                                                          .topLeft,
                                                      child: Stack(
                                                          children: <Widget>[
                                                            Text(
                                                              _result[index]
                                                                  .title,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .teal,
                                                                  fontWeight: FontWeight
                                                                      .bold),),
                                                          ]
                                                      )
                                                  )
                                                ]),
                                                Row(
                                                  children: [
                                                    _sources[_result[index]
                                                        .source].logo,
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10.0)),
                                                            color: Color(
                                                                _sources[_result[index]
                                                                    .source].color
                                                                    .value)
                                                        ),
                                                        padding: const EdgeInsets
                                                            .all(2.0),
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            16.0, 0.0, 0.0, 0.0),
                                                        child: Text(
                                                          _sources[_result[index]
                                                              .source].category,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ])
                                      ),
                                    ),
                                  )
                                  );
                                }
                            );
                          })

                ),
                    ]
                  )
              )

            /**floatingActionButton: FloatingActionButton(
                onPressed: fetchFeed,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
                ),**/
          )
      );
    }
    else{
      fetchFeed();
      return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
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
                actions: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            MenuView()),
                      );
                    },
                  ),
                ],
              ),
              body:const Center(child:CircularProgressIndicator())
          )
      );
    }
  }

  Future<void> _hasPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String topics = prefs.getString('prefTopics') ?? '';
    String lang = prefs.getString('lang') ?? '';
    if(lang == '' || topics == '') {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreferencesView())
      );
    }
  }

  _filter(String query) {
    List results = [];
    if (query.isNotEmpty) {
      results = _result
          .where((news) =>
          news.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if(results.isNotEmpty){
      _setList(results);
    }
  }

}
