import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:feed_you_flutter/Assets.dart';
import 'package:feed_you_flutter/WebView.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

  void _setList(list) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _result = list;
    });
  }

  Future<List> readFeedList(String lang, int index) async {
    try {
      Map<String, List> feeds = Assets().feeds(lang)!;
      return feeds.keys.contains(index.toString())? feeds[index.toString()]! :
        [];
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  void fetchFeed()  async {
    final prefs = await SharedPreferences.getInstance();

    //FINCHE NON AGGIUNGO METODO PER SETTARE PREFERENZE
    await prefs.setString('prefTopics', '[0.4, 0.04, 0.04, 0.04, 0.04, 0.04, 0.4]');
    await prefs.setString('lang', 'it');

    String stringTopics = prefs.getString('prefTopics') ?? '';
    String stringLang = prefs.getString('lang') ?? '';
    if (stringTopics == '' || stringLang == ''){
      _setList([]);
    }
    else {
      List<dynamic> prefTopics = jsonDecode(stringTopics);
      List<double> bounds = [];
      double rand = Random().nextDouble();
      bounds.add(prefTopics.first);
      int i = 1;
      for(; i< prefTopics.length && rand< bounds[i-1]; i++){
        bounds.add(bounds[i-1] + prefTopics[i]);
      }

      List feeds = await readFeedList(stringLang, i);
      feeds = (feeds.isNotEmpty) ? feeds : ["http://google.com"];
      var url = Uri.parse(feeds[0]);
      try {
        http.Response response = await http.get(url);
        if (response.statusCode == 200) {
          String data = response.body;
          var decodedData = RssFeed.parse(data);
          _setList(decodedData.items);
        } else {
          _setList([]);
        }
      } catch (e) {
        _setList([]);
      }
    }
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
            padding: const EdgeInsets.fromLTRB(4,10,4,0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:ListView.builder(
                  shrinkWrap: true,
                  itemCount: _result.length,
                  prototypeItem: ListTile(
                    title: Text(_result.isEmpty? "titolo" : _result.first.title),
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(title:GestureDetector(
                      onTap:  () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyWebView(link: _result[index].link)),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child:  Padding(
                          padding: EdgeInsets.all(7),
                          child: Stack(children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                children: <Widget>[
                                  Text(_result[index].title, style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
                                ]
                              )
                            )
                          ])
                        )
                    ))
                    );
                  }
              ),
            ),
          ),

          /**body:ListView.builder(
            itemCount: 1, //widget.items.length,
            prototypeItem: ListTile(
              title: FutureBuilder(
                future: Future {()=>_result},
              initialData: "Loading text..",
              builder: (BuildContext context, AsyncSnapshot<String> text) {
                return SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      text.data ?? "FLUTTER MERDA",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0,
                      ),
                    )
                );
              }),
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: FutureBuilder(
                  future: fetchFeed(),
                  initialData: "Loading text..",
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      String assets = snapshot.data.toString();
                      _incrementCounter(assets);
                    } else if (snapshot.hasError) {
                      setState(() {
                        _incrementCounter(snapshot.error.toString());
                      });
                    }
                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  }),
              );
            },
          ),**/
          /**Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,


              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),

                /**SingleChildScrollView(


                  child: Container(
                    color: Colors.white,
                    height: 200.0,
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  width: 200,
                                  height: 200,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),**/
              ],
            ),
          ),**/
          floatingActionButton: FloatingActionButton(
            onPressed: fetchFeed,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}
