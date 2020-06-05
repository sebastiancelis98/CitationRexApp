import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:flutter/material.dart';

class UserQuery{ //TODO Add Changenotifier

  List<String> queries;
  Map<String, Set<Recommendation>> recommendations;


  UserQuery({@required this.queries});

  
}