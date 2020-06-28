import 'package:CitationRexWebsite/model/userquery.dart';
import 'package:flutter/material.dart';
import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    UserQuery data = Provider.of<UserQuery>(context, listen: false);
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
                Builder(
                  builder: (context) {
                    switch (data.designVersion) {
                      case 1:
                        return HighlightableText(
                          text: widget.recommendation.title,
                          toHighlight: widget.recommendation.decisiveword,
                          enabled: hovering,
                        );
                      default:
                        return Text(
                          widget.recommendation.title,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                          ),
                        );
                    }
                  },
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
                ]),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
              icon: Icon(Icons.insert_link),
              onPressed: () async {
                String url = widget.recommendation.url;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
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

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: text.split(' ').map((String e) {
        final TextStyle style = TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
        );
        final Size txtSize = _textSize(e, style);
        if (!e.toLowerCase().contains(toHighlight.toLowerCase())) {
          return Text(
            e + ' ',
            style: style,
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
                  width: enabled ? txtSize.width : 0,
                  height: txtSize.height,
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
    return CircularProgressIndicator(
      strokeWidth: 1.5,
    );
  }
}
