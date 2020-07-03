import 'package:CitationRexWebsite/controller/recommender.dart';
import 'package:CitationRexWebsite/model/userquery.dart';
import 'package:CitationRexWebsite/utils/themes.dart';
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
    UserQuery data = Provider.of<UserQuery>(context, listen: false);

    String authors = widget.recommendation.authors;
    String allAuthors = authors;

    if (authors.split(',').length > 3) {
      authors = authors.split(',').getRange(0, 3).join(', ') +
          ", ...(+" +
          (authors.split(',').length - 3).toString() +
          ' more)';
    }

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
                  text: widget.recommendation.title +
                      (widget.recommendation.publishedYear != -1
                          ? (' (' +
                              widget.recommendation.publishedYear.toString() +
                              ')')
                          : ''),
                  toHighlight: widget.recommendation.decisiveWords,
                  enabled: hovering,
                ),
                Tooltip(
                  message: allAuthors,
                  waitDuration: Duration(milliseconds: 1000),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey[300],
                    ),
                  ),
                  verticalOffset: 8,
                  textStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                  ),
                  child: Text(
                    authors,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Builder(builder: (context) {
                  List<Widget> children = [];
                  if (widget.recommendation.venue != null) {
                    children.add(Text(
                      "In ",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ));

                    children.add(
                      Tooltip(
                        message: 'Published by: ' +
                            (widget.recommendation.publisher ??
                                'Unknown publisher'),
                        textStyle: TextStyle(fontFamily: 'Montserrat'),
                        preferBelow: false,
                        verticalOffset: 8,
                        waitDuration: Duration(milliseconds: 500),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey[300],
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          child: Text(
                            '"' +
                                capitalizeWords(
                                    widget.recommendation.venue ?? 'Unknown') +
                                '"',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Row(children: children);
                }),
                widget.recommendation.citationCount != -1
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            Text(
                              "This was cited by ",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                widget.recommendation.citationCount.toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              " other papers.",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ])
                    : Container(),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            MaterialButton(
              onPressed: () async {
                String url = widget.recommendation.url;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              elevation: 1.0,
              hoverElevation: 2,
              color: widget.recommendation.hasUrl ? Themes.primaryColor:Themes.primaryColor,
              child: widget.recommendation.hasUrl
                  ? Icon(
                      widget.recommendation.hasUrl
                          ? Icons.picture_as_pdf
                          : Icon,
                      color: Colors.white,
                      size: 24.0,
                    )
                  : Image(
                      image: AssetImage('assets/images/google_scholar.png'),
                      color: Colors.white,
                      height: 24,
                      width: 24,
                    ),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            ),
            SizedBox(width: 3)
          ],
        ),
      ),
    );
  }
}

class HighlightableText extends StatelessWidget {
  const HighlightableText(
      {Key key, this.text, this.toHighlight, this.enabled, this.fontSize = 14})
      : super(key: key);

  final String text;
  final List<String> toHighlight;
  final bool enabled;
  final double fontSize;

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
    final TextStyle style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: fontSize,
    );

    List<Widget> rowChildren = [];

    rowChildren.addAll(toHighlight.map((h) {
      String preText = '';
      String highlight = '';
      for (String s in text.split(' ')) {
        bool isDecisive = s.toLowerCase().startsWith(h.toLowerCase());
        if (isDecisive) {
          highlight = s;
          break;
        } else {
          preText += s + ' ';
        }
      }
      if (highlight == '') {
        return Container();
      }
      Size preSize = _textSize(preText, style);
      final Size txtSize = _textSize(highlight ?? '', style);

      return Positioned(
        left: preText == '' ? -1 : preSize.width - 2,
        child: Tooltip(
          message: '"' +
              capitalizeWords(highlight) +
              '"'
                  ' was particularly relevant for\nshowing this recommendation.',
          textStyle: style,
          preferBelow: true,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          waitDuration: Duration(milliseconds: 800),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[400],
              ),
              borderRadius: BorderRadius.circular(10)),
          child: AnimatedContainer(
            duration: Duration(milliseconds: enabled ? 900 : 0),
            curve: Curves.easeOutExpo,
            decoration: BoxDecoration(
                color: Colors.green[200],
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5)),
            width: enabled ? txtSize.width + (preText == '' ? 1.5 : 3) : 0,
            height: txtSize.height,
          ),
        ),
      );
    }).toList());

    rowChildren.add(Container(child: Text(text, style: style)));

    return Stack(children: rowChildren);
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
