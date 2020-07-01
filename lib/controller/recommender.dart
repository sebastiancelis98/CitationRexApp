import 'dart:convert';

import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:http/http.dart';

Future<Set<Recommendation>> getRecommendations(String query,
    {bool fallback = true}) async {
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
    print('Response:' +statusCode.toString());
    String data = response.body;
    
    if (statusCode != 200) {
      if (!fallback) {
        return null;
      }
      print('Trying fallback server...');
      String fallbackUrl =
          'http://aifb-ls3-vm1.aifb.kit.edu:5001/api/recommendation';
      Response response = await post(fallbackUrl, headers: headers, body: body);

      statusCode = response.statusCode;
      if (statusCode != 200) {
        return null;
      }
      data = response.body;
    }

    Map parsedData = json.decode(data);
    print(parsedData);

    int id = 1;
    for (Map paper in parsedData['papers']) {
      String title = paper['title'];
      String authors =
          paper['authors'].toString().replaceAll('[', '').replaceAll(']', '');
      authors = capitalizeWords(authors);

      String url;
      bool hasUrl = false;
      if (paper['url'] != null) {
        url = paper['url'];
        hasUrl = true;
      } else {
        url = 'https://scholar.google.com/scholar?q=' + title.split(' ').join("+");
      }
      
      if(paper['paperid'] != null){
        //TODO add other attributes
      }
      int paperId = paper['paperid'];

      int citationCount = paper['citationcount'];
      int year = paper['year'];
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
