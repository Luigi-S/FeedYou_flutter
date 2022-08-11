
import 'package:flutter/material.dart';

class NewsData {
  final String title;
  final String link;
  final int source;
  NewsData(this.title, this.link, this.source);
}

class SourceData {
  final String link;
  final Image logo;
  final String category;
  final Color color;
  SourceData(this.link, this.logo, this.category, this.color);
}