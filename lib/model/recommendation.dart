import 'package:flutter/cupertino.dart';

class Recommendation {
  int id, paperId, publishedYear, citationCount, referenceCount;
  String title, authors, url, venue, publisher;

  List<String> decisiveWords;

  Recommendation(
      {@required this.id,
      @required this.paperId,
      @required this.title,
      @required this.url,
      this.authors,
      this.decisiveWords,
      this.publishedYear = 2020,
      this.citationCount = 0,
      this.referenceCount = 0,
      this.venue = "",
      this.publisher = ""});
}
