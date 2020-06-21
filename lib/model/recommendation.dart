import 'package:flutter/cupertino.dart';

class Recommendation{

  int id;
  String title, authors, decisivewords;
  

  Recommendation({@required this.id, @required this.title, this.authors, this.decisivewords});

}