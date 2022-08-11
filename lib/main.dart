import 'dart:convert';
import 'dart:math';

import 'package:favicon/favicon.dart' as favicon;
import 'package:feed_you_flutter/Assets.dart';
import 'package:feed_you_flutter/NewsData.dart';
import 'package:feed_you_flutter/WebView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //List items = List.generate(100, (i) => fetch());

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //
        //
        // primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Feed You'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    print("YOU PRESSED IT");
    final prefs = await SharedPreferences.getInstance();

    //FINCHE NON AGGIUNGO METODO PER SETTARE PREFERENZE
    await prefs.setString('prefTopics', '[0.4, 0.04, 0.04, 0.04, 0.04, 0.04, 0.4]');
    await prefs.setString('lang', 'it');

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
      //TODO testo sballa caratteri

      for (String topic in feeds.keys){
        newsByTopic.add(<NewsData>[]);
        for (int i =0 ;i<feeds[topic]!.length; i++){
          var url = Uri.parse(feeds[topic]![i]);
          try {
            http.Response response1 = await http.get(url);
            if (response1.statusCode == 200) {
              String data = response1.body;
              var decodedData = RssFeed.parse(data);
              List<RssItem> items = decodedData.items!;

              /**var url = Uri.parse(items.first.link!);
              http.Response response = await http.get(url);
              if (response.statusCode == 200) {
                String doc = response.body;
                dom.Element? icon;
                try {
                  icon = parse(doc).head?.querySelector("<html link>");//("link[href~=.*\\.(ico|png)]")!;
                } catch (e) {
                  try {
                    icon = parse(doc).head?.querySelector("meta[itemprop=image]")!;
                  } catch (e) {
                    ;
                  }
                }
                favicon = icon?.querySelector("href")?.text;
                if (favicon?.startsWith('/') == true) {
                  favicon = favicon!.substring(favicon.indexOf('/'));
                  if (favicon.startsWith('/')) {
                    favicon = favicon.substring(favicon.indexOf('/'));
                  }
                  if (!favicon.startsWith("www")) {
                    var baseurl = items.first.link!.split('/');
                    favicon = baseurl[0] + "//" + baseurl[2] + '/' + favicon;
                  } else {
                    favicon = "https://$favicon";
                  }
                }
              }**/

              favicon.Icon? ico = await favicon.Favicon.getBest(items.first.link!);
              String favUrl = ico?.url ?? "https://google.com/favicon.ico";
              Image img = Image.network(
                  favUrl,
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill);

              Color col = Assets().topicColor(int.parse(topic));
              sources.add(SourceData(feeds[topic]![i], img, topics[int.parse(topic)], col));

              for (RssItem item in items) {
                newsByTopic[int.parse(topic)].add(
                    NewsData(item.title!, item.link!, sources.length-1));
              }
              newsByTopic[int.parse(topic)].shuffle();
            }
          } catch (e) {;}
        }
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title:const Text(
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
            padding: const EdgeInsets.fromLTRB(4,10,4,10),
            child: DraggableScrollableSheet(
              minChildSize: 0,
              maxChildSize: 1,
              initialChildSize: 1,
              builder:(context, scrollController) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _result.length,
                    itemBuilder: (context, index) {
                      return ListTile(title:GestureDetector(
                          onTap:  () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyWebView(link: _result[index].link)),
                            );
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                              margin: const EdgeInsets.all(4.0),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children:[
                                        Stack(children: <Widget>[
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Stack(
                                                children: <Widget>[
                                                  Text(_result[index].title, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
                                                ]
                                            )
                                          )
                                        ]),
                                        Row(
                                          children: [
                                            _sources[_result[index].source].logo,
                                            Container(
                                                decoration: BoxDecoration (
                                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                    color: Color(_sources[_result[index].source].color.value)
                                                ),
                                                padding: const EdgeInsets.all(2.0),
                                                margin: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  _sources[_result[index].source].category,
                                                  style: const TextStyle(color: Colors.white  ),
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

          floatingActionButton: FloatingActionButton(
            onPressed: fetchFeed,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }

}
