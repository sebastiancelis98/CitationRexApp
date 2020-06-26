import 'package:flutter/material.dart';
import 'package:CitationRexWebsite/model/recommendation.dart';

class RecommendationTile extends StatelessWidget {
  final Recommendation recommendation;

  RecommendationTile({@required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {},
      onExit: (e) {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                "#" + (recommendation.id).toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 14),
              ),
              backgroundColor: Colors.transparent,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HighlightableText(
                  text: recommendation.title,
                  toHighlight: recommendation.decisiveword,
                  enabled: true,
                ),
                Text(
                  recommendation.authors,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 5),
                Row(children: <Widget>[
                  Text(
                    "Decisive words: ",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(recommendation.decisiveword ?? '',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Colors.black,
                      ))
                ])
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
      ),
    );
  }
}

class HighlightableText extends StatelessWidget {
  const HighlightableText({
    Key key,
    this.text,
    this.toHighlight,
    this.enabled,
  }) : super(key: key);

  final String text;
  final String toHighlight;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: text.split(' ').map((e) {
        if (e.toLowerCase().contains(toHighlight.toLowerCase())) {
          return Row(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                child: Text(
                  e,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5)),
              ),
              Text(' ',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ))
            ],
          );
        } 
        return Text(e + ' ',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
            ));
      }).toList(),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}
