import 'package:flutter/cupertino.dart';

class Recommendation {
  int id, paperId, publishedYear, citationCount, referenceCount;
  String title, authors, decisiveword, url;

  Recommendation(
      {@required this.id,
      @required this.paperId,
      @required this.title,
      @required this.url,
      this.authors,
      this.decisiveword,
      this.publishedYear,
      this.citationCount,
      this.referenceCount});
}
