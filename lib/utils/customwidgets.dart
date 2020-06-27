import 'package:flutter/material.dart';
import 'package:CitationRexWebsite/model/recommendation.dart';

class RecommendationTile extends StatefulWidget {
  final Recommendation recommendation;

  RecommendationTile({@required this.recommendation});

  @override
  _RecommendationTileState createState() => _RecommendationTileState();
}

class _RecommendationTileState extends State<RecommendationTile> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (e) {
        setState(() {
          hovering = false;
        });
      },
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
                "#" + (widget.recommendation.id).toString(),
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
                  text: widget.recommendation.title,
                  toHighlight: widget.recommendation.decisiveword,
                  enabled: hovering,
                ),
                Text(
                  widget.recommendation.authors,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 5),
                Row(children: <Widget>[
                  Text(
                    "Decisive word: ",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(widget.recommendation.decisiveword ?? '',
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
              icon: Icon(Icons.insert_link),
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
      children: text.split(' ').map((String e) {
        if(!e.toLowerCase().contains(toHighlight.toLowerCase())){
          return Text(
            e + ' ',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
          );
        }
        return Row(
          children: [
            Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOutExpo,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(4)),
                  width: enabled ? e.length*7.5 : 0,
                  height: 17,
                ),
                Container(
                  child: Text(
                    e,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            Text(' ')
          ],
        );
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
