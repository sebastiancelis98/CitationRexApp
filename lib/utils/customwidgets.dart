import 'package:flutter/material.dart';
import 'package:CitationRexWebsite/model/recommendation.dart';

class RecommendationTile extends StatelessWidget {
  final Recommendation recommendation;

  RecommendationTile({@required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: Text(
              "#" + (recommendation.id).toString(),
              style: TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontSize: 14),
            ),
            backgroundColor: Colors.transparent,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                recommendation.title,
                
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
              ),
              Text(
                recommendation.authors,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {},
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          SizedBox(width: 10)
        ],
      ),
    );

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
