import 'dart:convert';

import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:http/http.dart';

Future<Set<Recommendation>> getRecommendations(String query) async {
  if (query == null || query.isEmpty) {
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
       return null;
    }

    Map parsedData = json.decode(data);
    print(parsedData);

    int id = 1;
    for (Map paper in parsedData['papers']) {
      String title = paper['title'];
      String authors =
          paper['authors'].toString().replaceAll('[', '').replaceAll(']', '');
      authors = capitalizeWords(authors);
      String url = paper['url'];

      int referenceCount = paper['referencecount'];
      int citationCount = paper['citationCount'];
      int year = paper['year'];
      int paperId = paper['paperid'];

      Recommendation rec = Recommendation(
          id: id++,
          paperId: paperId,
          url: url,
          authors: authors,
          title: title,
          decisiveword: paper['decisive_word'],
          referenceCount: referenceCount,
          citationCount: citationCount,
          publishedYear: year);
      recs.add(rec);
      if(recs.length >= 15){
        break;
      }
    }
  } catch (e) {
    print(e);
  }
  return recs;
}

String capitalizeWords(String input) {
  return input
      .split(" ")
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .join(' ');
}
