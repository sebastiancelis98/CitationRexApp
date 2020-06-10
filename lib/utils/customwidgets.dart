import 'package:flutter/material.dart';
import 'package:CitationRexWebsite/model/recommendation.dart';

class RecommendationTile extends StatelessWidget {
  final Recommendation recommendation;

  RecommendationTile({@required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          onTap: () {},
          title: Text(recommendation.title),
          subtitle: Text(recommendation.authors),
          leading: CircleAvatar(
            child: Text((recommendation.id).toString(),
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
          ),
          trailing: Icon(Icons.archive)),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
