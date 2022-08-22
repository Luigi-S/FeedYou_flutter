import 'package:flutter/material.dart';

class Assets{
  List<String> langs(){
    return ["it","en"];
  }
  String fullLangName(String lang){
    Map<String,String> map = {"it": "Italiano","en": "English"};
    return map.keys.contains(lang)? map[lang]! : "Italiano";
  }
  List<String> topics(String lang){
    const topics = {
      "it":["Top News","Cronaca","Politica","Economia","Costume e Società","Cinema e Cultura","Sport"],
      "en":["Top News","Cronaca","Politics","Economy","Society","Culture","Sports"]
    };
    return (topics.keys.contains(lang))? topics[lang]! : topics["en"]!;
  }
  Color topicColor(int index){
    List<Color> colors = [
      const Color(0xff606060),
      const Color(0xff006e8c),
      const Color(0xffe93578),
      const Color(0xffe61610),
      const Color(0xff4c7a34),
      const Color(0xff232323),
      const Color(0xff1c0c4f)
    ];
    return index<colors.length? colors[index] : colors.last;
  }

  Map<String, List>? feeds(String lang){
    const feeds = {
      "it": {
        "0": [
          "https://www.italpress.com/rss",
          "https://www.corriere.it/rss/homepage.xml",
          "https://www.ilfattoquotidiano.it/rss",
          "https://www.ilsole24ore.com/rss/italia--in-edicola.xml",
          "http://www.repubblica.it/rss/homepage/rss2.0.xml?ref=RHFT",
          "https://www.ansa.it/sito/ansait_rss.xml",
          "http://www.ansa.it/sito/notizie/topnews/topnews_rss.xml",
          "http://www.tgcom24.mediaset.it/rss/homepage.xml",
          "https://it.notizie.yahoo.com/rss"
        ],
        "1": ["https://www.ansa.it/sito/notizie/cronaca/cronaca_rss.xml"],
        "2": ["https://www.ansa.it/sito/notizie/politica/politica_rss.xml"],
        "3": ["https://www.ansa.it/sito/notizie/economia/economia_rss.xml"],
        "4": ["https://www.ansa.it/sito/notizie/mondo/mondo_rss.xml"],
        "5": [
          "http://www.ansa.it/sito/notizie/cultura/cultura_rss.xml",
          "https://www.ilsole24ore.com/rss/cultura.xml"
        ],
        "6": [
          "https://www.ultimouomo.com/feed",
          "https://www.gazzetta.it/rss/home.xml",
          "https://www.corrieredellosport.it/rss"
        ]
      },
      "en": {
        "0": [
          "http://rss.cnn.com/rss/cnn_topstories.rss",
          "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
          ],
        "1": [
          "http://www.npr.org/rss/rss.php?id=1001",
          "https://www.buzzfeed.com/world.xml"
          ],
        "2": ["https://www.theguardian.com/politics/rss"],
        "3": ["https://www.economist.com/finance-and-economics/rss.xml"],
        "4": ["https://www.theguardian.com/society/rss"],
        "5":[
          "https://feeds.npr.org/1008/rss.xml",
          "https://feeds.npr.org/1045/rss.xml"
          ],
        "6": [
          "https://rss.nytimes.com/services/xml/rss/nyt/Sports.xml"
          ]
        }
      };
    var result =  (feeds.keys.contains(lang)) ?
      feeds[lang] :
      {"0":[],"1":[],"2":[],"3":[],"4":[],"5":[],"6":[]};
    return result;
    }
}