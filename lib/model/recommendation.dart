import 'package:flutter/cupertino.dart';

class Recommendation {
  int id, paperId, publishedYear, citationCount, referenceCount;
  String title, authors, url;
  
  List<String> decisiveWords;

  Recommendation(
      {@required this.id,
      @required this.paperId,
      @required this.title,
      @required this.url,
      this.authors,
      this.decisiveWords,
      this.publishedYear,
      this.citationCount = 0,
      this.referenceCount = 0});
}
