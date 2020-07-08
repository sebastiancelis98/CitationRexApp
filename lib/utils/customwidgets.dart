import 'package:CitationRexWebsite/controller/recommender.dart';
import 'package:CitationRexWebsite/model/userquery.dart';
import 'package:CitationRexWebsite/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:flutter/services.dart';
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
    Recommendation rec = widget.recommendation;

    String authors = rec.authors;
    String allAuthors = authors;
    String title = rec.title;
    String fullTitle = rec.title;

    if (authors.split(',').length > 3) {
      authors = authors.split(',').getRange(0, 3).join(', ') +
          ", ...(+" +
          (authors.split(',').length - 3).toString() +
          ' more)';
    }
    if (title.split(" ").length > 6) {
      title = title.split(' ').getRange(0, 6).join(' ') + "...";
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
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),
              padding: EdgeInsets.all(8),
              child: Text(
                '#' + (rec.id).toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 13),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 35),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //SizedBox(height: 2),
                      title == fullTitle
                          ? Text(title,
                              style: TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 14))
                          : Tooltip(
                              message: fullTitle,
                              waitDuration: Duration(milliseconds: 800),
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
                                fontSize: 14,
                              ),
                              child: Text(title,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 14)),
                            ),
                      authors == allAuthors
                          ? Text(
                              authors,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            )
                          : Tooltip(
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
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Tooltip(
                          message:
                              'Copy bibliography citation to your clipboard',
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[300],
                            ),
                          ),
                          verticalOffset: 20,
                          textStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                          ),
                          child: InkWell(
                            onTap: () {
                              String bibTex = '@article{';

                              List<String> attributes = [
                                rec.title.split(' ').join('_'),
                                'title={' + rec.title + '}',
                                'author={' + rec.authors + '}',
                              ];
                              if (rec.paperId != -1) {
                                attributes.addAll([
                                  'url={' + rec.url + '}',
                                  'year={' + rec.publishedYear.toString() + '}',
                                ]);
                                if (rec.venue != null) {
                                  attributes.add(
                                    'venue={' + rec.venue + '}',
                                  );
                                }
                                if (rec.publisher != null) {
                                  attributes
                                      .add('publisher={' + rec.publisher + '}');
                                }
                              }
                              bibTex += attributes.join(', ');
                              bibTex += '}';

                              SnackBar bar = SnackBar(
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Copied citation to clipboard!',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                            fontSize: 14)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 18,
                                    )
                                  ],
                                ),
                                backgroundColor: Colors.white,
                                behavior: SnackBarBehavior.fixed,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey[400]),
                                    borderRadius: BorderRadius.circular(15)),
                              );

                              Clipboard.setData(ClipboardData(text: bibTex));
                              Scaffold.of(context).showSnackBar(bar);

                              print(bibTex);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[300]),
                                padding: EdgeInsets.all(7),
                                child: Icon(Icons.content_copy, size: 22)),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                          width: 8,
                        ),
                        Tooltip(
                          message: rec.hasUrl
                              ? 'Go to paper'
                              : 'Search on Google Scholar',
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[300],
                            ),
                          ),
                          verticalOffset: 20,
                          textStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                          ),
                          child: InkWell(
                            onTap: () async {
                              String url = rec.url;
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300),
                              padding: EdgeInsets.all(7),
                              child: rec.hasUrl
                                  ? Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.black,
                                      size: 22.0,
                                    )
                                  : Image(
                                      image: AssetImage(
                                          'assets/images/google_scholar.png'),
                                      color: Colors.black,
                                      height: 24,
                                      width: 24,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
