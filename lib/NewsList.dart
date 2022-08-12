
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

    //FINCHE NON AGGIUNGO METODO PER SETTARE PREFERENZE
    //TODO rimuovere quando inserita selezione preferenze
    //await prefs.setString('prefTopics', '[0.4, 0.04, 0.04, 0.04, 0.04, 0.04, 0.4]');
    //await prefs.setString('lang', '');

    //lista da popolare con le notizie da far comparire
    List news = [];
    List sources = [];

    String stringTopics = prefs.getString('prefTopics') ?? '';
    String stringLang = prefs.getString('lang') ?? '';
    List<String> topics = Assets().topics(stringLang);
    if (stringTopics != '' && stringLang != ''){
      List<dynamic> prefTopics = jsonDecode(stringTopics);
      List<double> bounds = [];
      bounds.add(prefTopics.first);
      for(int i = 1; i< prefTopics.length; i++){
        bounds.add(bounds[i-1] + prefTopics[i]);
      }

      //lista dei link ai feed di una lingua, divisi per topic
      Map<String, List> feeds = Assets().feeds(stringLang)!;
      List newsByTopic = [];

      //TODO per rapidità questa versione non ha i link bloccati

      for (String topic in feeds.keys){
        newsByTopic.add(<NewsData>[]);
        for (int i =0 ;i<feeds[topic]!.length; i++){
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

      for(int j =0; j<40; j++){
        double rand = Random().nextDouble();
        int i =0;
        while(i< bounds.length && rand>bounds[i]){i++;}
        if(newsByTopic[i].isNotEmpty) {
          news.add(newsByTopic[i].removeAt(0));
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
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
            ],
          ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) => fetchFeed());

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.


    if (_result.isNotEmpty) {
      return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                  "Feed You",
                  style: TextStyle(
                      fontFamily: 'RockSalt',
                      color: Colors.teal,
                      fontSize: 20.0
                  )
              ),
            ),

            body:
            RefreshIndicator(
                onRefresh: () async {
                  return fetchFeed();
                },
                child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                    child: DraggableScrollableSheet(
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
                                          MyWebView(link: _result[index].link)),
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
                )
            ),

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
                title: const Text(
                    "Feed You",
                    style: TextStyle(
                        fontFamily: 'RockSalt',
                        color: Colors.teal,
                        fontSize: 20.0
                    )
                ),
              ),
              body:const Center(child:CircularProgressIndicator())
          )
      );
    }
  }

}
