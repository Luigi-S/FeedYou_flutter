class Assets{
  List<String> langs(){
    return ["it","en","fr","de"];
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
      "en": {"0":[],"1":[],"2":[],"3":[],"4":[],"5":[],"6":[],"7":[]},
      "fr": {"0":[],"1":[],"2":[],"3":[],"4":[],"5":[],"6":[],"7":[]},
      "de": {"0":[],"1":[],"2":[],"3":[],"4":[],"5":[],"6":[],"7":[]},
      };
    var result =  (feeds.keys.contains(lang)) ?
      feeds[lang] :
      {"0":[],"1":[],"2":[],"3":[],"4":[],"5":[],"6":[],"7":[]};
    return result;
    }
}