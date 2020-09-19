import 'dart:convert';

import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:http/http.dart';

Future<Set<Recommendation>> getRecommendations(String query,
    {bool fallback = false}) async {
  if (query == null || query.isEmpty) {
    return null;
  }

  Set<Recommendation> recs = Set();

  String url = 'http://81.169.168.47:5000/api/recommendation';

  if(fallback){
    print('Attempting with fallback server...');
    url = 'http://aifb-ls3-vm1.aifb.kit.edu:5000/api/recommendation';
  }

  Map<String, String> headers = {
    "Content-type": "application/json",
  };
  String body = '{"query": "$query"}';

  try {
    Response response = await post(url, headers: headers, body: body);

    int statusCode = response.statusCode;
    print('Response:' +statusCode.toString());
    String data = response.body;
    
    if (statusCode != 200) {
      return null;
    }

    Map parsedData = json.decode(data);
    print(parsedData);

    int id = 1;
    for (Map paper in parsedData['papers']) {
      String title = paper['title'];
      if(title[0] != title[0].toUpperCase()){
        title = capitalizeWords(title);
      }

      String authors =
          paper['authors'].toString().replaceAll('[', '').replaceAll(']', '');
      authors = capitalizeWords(authors);

      String url;
      bool hasUrl = false;
      if (paper['url'] != null) {
        url = paper['url'];
        hasUrl = true;
      } else {
        url = 'https://scholar.google.com/scholar?q=' + title.split(' ').join("+")+'+'+authors.split(",").map((e) => e.split(" ").join("+")).join("+");
      }

      int paperId = paper['paperid'] ?? -1;

      int citationCount = paper['citationcount'] ?? -1;
      int year = paper['year'] ?? -1;
      String venue = paper['venue'];
      String publisher = paper['publisher'];
      List<dynamic> decisiveWords = paper['decisive_words'];

      Recommendation rec = Recommendation(
          id: id++,
          paperId: paperId,
          url: url,
          authors: authors,
          title: title,
          decisiveWords: decisiveWords.map((e) => e.toString()).toList(),
          citationCount: citationCount,
          publishedYear: year,
          venue: venue,
          publisher: publisher,
          hasUrl: hasUrl);

      recs.add(rec);
      if (recs.length >= 15) {
        break;
      }
    }
  } catch (e) {
    if(!fallback){
      return getRecommendations(query, fallback: true);
    }
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
