import 'package:flutter/cupertino.dart';

class Recommendation{

  int id, paperId;
  String title, authors, decisiveword;
  

  Recommendation({@required this.id, @required this.paperId, @required this.title, this.authors, this.decisiveword});

}