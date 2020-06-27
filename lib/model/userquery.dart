import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:flutter/material.dart';
import 'package:CitationRexWebsite/controller/recommender.dart';

class UserQuery with ChangeNotifier {

  int designVersion;
  List<String> queries;
  Map<String, Set<Recommendation>> recommendations = Map();

  void updateQueries(List<String> queries) {
    this.queries = queries;
    fetchRecommendations();
    notifyListeners();
  }

  void fetchRecommendations(){
    print('Fetching recommendations...');
    for (String query in queries) {
      if (recommendations.containsKey(query)) {
        continue;
      }
      getRecommendations(query).then((value) {
        recommendations.putIfAbsent(query, () => value);
        notifyListeners();
      });
    }
  }
}
