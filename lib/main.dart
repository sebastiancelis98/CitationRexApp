import 'dart:html';

import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:CitationRexWebsite/model/userquery.dart';
import 'package:CitationRexWebsite/utils/color.dart';
import 'package:CitationRexWebsite/utils/customwidgets.dart';
import 'package:CitationRexWebsite/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker_web/file_picker_web.dart';
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';

void main() {
  runApp(MyApp());
}

/*
Base version:
 - Title
 - Authors
 - Link

Version 2:
 - Cited by
 - Venue
 - Year

Version 3:
 - Highlight decisive words (currently 2)
 - Summary of all decisive words
 - 
*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserQuery>.value(
      value: UserQuery(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => RootPage(),
        },
        title: 'Citation Rex',
        debugShowCheckedModeBanner: false,
        theme: Themes().lightTheme(),
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  RootPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicBody(),
      backgroundColor: HexColor.fromHex('F0F0F0'),
    );
  }
}

class DynamicBody extends StatefulWidget {
  @override
  _DynamicBodyState createState() => _DynamicBodyState();
}

class _DynamicBodyState extends State<DynamicBody> {
  TextEditingController _textController = TextEditingController();

  String _errorText;

  bool _validateInput(String input) {
    //TODO change to 15 words min when in production mode
    if (_textController.text.split(" ").length < 8 && kReleaseMode) {
      setState(() {
        _errorText = 'Please enter a sentence with 8 words or more!';
      });
      return false;
    }
    if (_textController.text.split(" ").length < 15) {
      setState(() {
        _errorText =
            'Warning: Sentences with less than 15 words provide less accurate results...';
      });
    } else {
      _errorText = null;
    }
    return true;
  }

  List<String> _splitInput(String input) {
    List<String> queries = List();

    String currentSentence = "";
    for (String query in input.split(".")) {
      if (currentSentence != "") {
        currentSentence += ". " + query;
      } else {
        currentSentence = query;
      }
      //If the combined sentence contains less than 15 words, merge it with the next sentence
      if (currentSentence.split(" ").length < 15) {
        continue;
      }
      //Clean up the sentence
      currentSentence =
          currentSentence.trim().replaceAll('"', '').replaceAll("'", "");

      queries.add(currentSentence);
      currentSentence = "";
    }
    if (currentSentence.trim() != "") queries.add(currentSentence);
    return queries;
  }

  bool designTest = false;

  @override
  Widget build(BuildContext context) {
    UserQuery queryData = Provider.of<UserQuery>(context, listen: false);
    bool expandedInput = queryData.queries == null || queryData.queries.isEmpty;

    if (designTest) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 370, vertical: 50),
            child: RecommendationTile(
              recommendation: Recommendation(
                  id: 1,
                  paperId: -1,
                  url: 'http://google.com',
                  title:
                      'This is a test sample for design, that could be very very very very very long...',
                  authors: 'Isabela, Vinzenz & Sebastian',
                  citationCount: 69,
                  venue: "papers that can be used as examples",
                  publisher: "Springer",
                  decisiveWords: ["test", "design"]),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            gradient: LinearGradient(
              colors: [Colors.grey[200], Colors.grey[300]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent, //Change to grey[400] maybe?
                blurRadius: 4.0,
              )
            ],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Citation Rex',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Theme.of(context).primaryColor,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      ' Get useful paper recommendations for your research.',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.grey[800]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 750),
                    curve: Curves.easeOutExpo,
                    margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width *
                        (expandedInput ? 58 : 42) /
                        100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[600]),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: TextField(
                      maxLines: (MediaQuery.of(context).size.height ~/ 28),
                      controller: _textController,
                      cursorColor: Colors.grey[850],
                      style: TextStyle(fontSize: 14, fontFamily: 'Montserrat'),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          errorText: _errorText,
                          errorStyle: TextStyle(fontFamily: 'Montserrat'),
                          hintText: 'Paste a section from your paper here...'),
                    ),
                  ),
                  Expanded(child: Container()),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            String _query =
                                _textController.text.replaceAll('\n', ' ');

                            if (!_validateInput(_query)) {
                              return;
                            }

                            setState(() {
                              List<String> queries = _splitInput(_query);

                              print("Queries: " + queries.toString());
                              queryData.updateQueries(queries);
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Theme.of(context).primaryColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Search ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Montserrat'),
                              ),
                              Icon(Icons.search, color: Colors.white, size: 21),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Text('or',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey[600])),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            File file = await FilePicker.getFile(
                                allowedExtensions: ['.txt'],
                                type: FileType.custom);
                            FileReader reader = new FileReader();

                            reader.onLoad.listen((e) {
                              String text = reader.result;
                              _textController.text = text;
                            });
                            reader.readAsText(file);
                            //reader.abort();

                            setState(() {});
                          },
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: Row(
                            children: [
                              Text(
                                'Import ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.insert_drive_file,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.grey[300],
                        ),
                      ]),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              Expanded(
                child: QuerySelector(),
              )
            ],
          ),
        )
      ],
    );
  }
}

class QuerySelector extends StatefulWidget {
  @override
  _QuerySelectorState createState() => _QuerySelectorState();
}

class _QuerySelectorState extends State<QuerySelector> {
  String selectedQuery;
  int currentIndex = 0;
  bool showDecisive = false;

  @mustCallSuper
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserQuery queryData = Provider.of<UserQuery>(context);
    if (queryData == null) {
      print('Error');
    }
    List queries = queryData.queries;

    if (queries == null) {
      return Container();
    }

    if (currentIndex > queries.length - 1) currentIndex = queries.length - 1;

    String selectedQuery = queries.elementAt(currentIndex);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Opacity(
                    opacity: currentIndex != 0 ? 1 : 0.35,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(Icons.keyboard_arrow_left,
                            color: Colors.white),
                        onPressed: () {
                          if (currentIndex != 0) {
                            setState(() {
                              currentIndex--;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          selectedQuery,
                          style:
                              TextStyle(fontFamily: 'Montserrat', fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: currentIndex < queries.length - 1 ? 1 : 0.35,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(Icons.keyboard_arrow_right,
                            color: Colors.white),
                        onPressed: () {
                          if (currentIndex < queries.length - 1) {
                            setState(() {
                              currentIndex++;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    queries.length > 1
                        ? '${currentIndex + 1} of ${queries.length}'
                        : '',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Builder(
                builder: (context) {
                  int totalOccurences = 0;

                  Map<String, int> decisiveMapping = {};

                  if (queryData.recommendations.containsKey(selectedQuery)) {
                    for (Recommendation r
                        in queryData.recommendations[selectedQuery]) {
                      for (String s in r.decisiveWords) {
                        if (decisiveMapping.containsKey(s)) {
                          decisiveMapping[s]++;
                        } else {
                          decisiveMapping.putIfAbsent(s, () => 1);
                        }
                        totalOccurences++;
                      }
                    }
                  } else {
                    return Container();
                  }

                  List<Widget> widgets = [];

                  decisiveMapping.forEach((key, value) {
                    if (value < 2) {
                      return;
                    }
                    String percentage =
                        ((value * 200 ~/ totalOccurences)).toString() + '%';

                    widgets.add(Tooltip(
                      waitDuration: Duration(milliseconds: 800),
                      verticalOffset: 30,
                      message: '"' +
                          key[0].toUpperCase() +
                          key.substring(1) +
                          '" was relevant in ' +
                          percentage +
                          '\nof the recommended papers.',
                      preferBelow: false,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[400]),
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: TextStyle(fontFamily: 'Montserrat'),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          child: Text(
                            key + ' (' + percentage + ')',
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 12),
                          )),
                    ));
                  });

                  int rows = widgets.length ~/ 3;
                  if (rows == 0) rows = 1;

                  List<Widget> columnChildren = [];

                  if (widgets.length > 0) {
                    columnChildren.add(GestureDetector(
                      onTap: () {
                        setState(() {
                          showDecisive = !showDecisive;
                        });
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Most relevant words ',
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 12)),
                            Icon(
                              showDecisive
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ));
                  }

                  if (showDecisive) {
                    for (int i = 0; i < rows; i++) {
                      columnChildren.add(SizedBox(
                        height: 4,
                      ));
                      int end = (i + 1) * 4;
                      if (end > widgets.length) end = widgets.length;
                      columnChildren.add(Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widgets.sublist(i * 4, end),
                      ));
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: columnChildren,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        RecList(query: selectedQuery),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class RecList extends StatelessWidget {
  final String query;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  RecList({this.query});

  @override
  Widget build(BuildContext context) {
    UserQuery queryData = Provider.of<UserQuery>(context, listen: false);
    if (query == null || query == '') {
      return Container();
    }
    if (!queryData.recommendations.containsKey(query)) {
      return Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Loading(),
          SizedBox(height: 20,),
          Text('Loading...',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
              )),
          SizedBox(height: 2),
          Text('(Processing the recommendations could take about 10s)',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
              )),
          
        ],
      );
    }
    Set<Recommendation> recs = queryData.recommendations[query];
    if (recs.isEmpty) {
      if (kReleaseMode) {
        return Text(
          'There has been an error retrieving the recommendations, please try again later!',
          style: TextStyle(
              color: Colors.red, fontSize: 12, fontFamily: 'Montserrat'),
        );
      }
      recs.addAll(List.generate(
          10,
          (index) => Recommendation(
              id: index + 1,
              paperId: 59225,
              url: 'http://google.com',
              title:
                  'Error retrieving recommendations, this is a test sample, that is really really long',
              authors: 'Isabela, Vinzenz & Sebastian',
              citationCount: 69,
              venue: "papers that can be used as examples",
              publisher: "Springer",
              decisiveWords: ["retrieving", "sample"])));
    }

    return Expanded(
      child: Scrollbar(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: ListView.builder(
            itemCount: recs.length,
            itemBuilder: (context, i) {
              return RecommendationTile(
                recommendation: recs.elementAt(i),
              );
            },
          ),
        ),
      ),
    );
  }
}
