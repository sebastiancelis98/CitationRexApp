import 'dart:convert';

import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:http/http.dart';

Future<Set<Recommendation>> getRecommendations(String query) async {
  if(query == null || query.isEmpty){
    return null;
  }
  Set<Recommendation> recs = Set();

  String url = 'http://aifb-ls3-vm1.aifb.kit.edu:5000/api/recommendation';

  Map<String, String> headers = {
    "Content-type": "application/json",
  };
  String body = '{"query": "$query"}';

  try {
    Response response = await post(url, headers: headers, body: body);

    int statusCode = response.statusCode;
    String data = response.body;
    if (statusCode != 200) {
      //To test in case backend doesn't currently work
      //String data =            "{ \"papers\" : [ {\"id\": 1,\"title\": \"Image Classification with CNN\",   \"description\": \"Celis et al 2021 - ACM\" },  {\"id\": 2,  \"title\": \"Neural Citation Recommendation\", \"description\": \"Need to find a good Python tutorial on the web\" }]}";
      return null;
    }

    Map parsedData = json.decode(data);
    print(parsedData);
    
    int id = 1;
    for(Map paper in parsedData['papers']){
      String title = capitalizeWords(paper['title']);
      String authors = paper['authors'].toString().replaceAll('[', '').replaceAll(']', '');
      authors = capitalizeWords(authors);
      int paperId = paper['paperid'];
      
      Recommendation rec = Recommendation(
        id: id++,
        paperId: paperId,
        authors: authors,
        title: title,
        decisiveword: paper['decisive_word']
      );
      recs.add(rec);
    }

    
  } catch (e) {
    print(e);
  }
  return recs;
}

String capitalizeWords(String input){
  return input.split(" ").map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
}
