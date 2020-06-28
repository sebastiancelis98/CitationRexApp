import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:CitationRexWebsite/model/userquery.dart';
import 'package:CitationRexWebsite/utils/color.dart';
import 'package:CitationRexWebsite/utils/customwidgets.dart';
import 'package:CitationRexWebsite/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

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
          '/2': (context) => RootPage(designVersion: 2),
        },
        title: 'Citation Rex',
        debugShowCheckedModeBanner: false,
        theme: Themes().lightTheme(),
      ),
    );
  }
}

class RootPage extends StatelessWidget {

  final int designVersion;

  RootPage({this.designVersion = 1});

  @override
  Widget build(BuildContext context) {
    UserQuery queryData = Provider.of<UserQuery>(context, listen: false);
    queryData.designVersion = designVersion;

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

  @override
  Widget build(BuildContext context) {
    UserQuery queryData = Provider.of<UserQuery>(context, listen: false);

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
                        color: Colors.grey[800]
                      ),
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
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 46 / 100,
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
                      maxLines: 20,
                      controller: _textController,
                      cursorColor: Theme.of(context).secondaryHeaderColor,
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
                  SizedBox(height: 20),
                  Center(
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Theme.of(context).primaryColor,
                      elevation: 1,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      onPressed: () {
                        //TODO change to 15 words min when in production mode
                        if (_textController.text.split(" ").length < 2) {
                          setState(() {
                            _errorText =
                                'Please enter a sentence with 2 words or more!';
                          });
                          return;
                        }
                        _errorText = null;
                        setState(() {
                          String _query =
                              _textController.text.replaceAll('\n', ' ');

                          List<String> queries = List();

                          String currentSentence = "";
                          for (String query in _query.split(".")) {
                            print("Query: " + query);
                            print("Current sentence: " + currentSentence);

                            if (currentSentence != "") {
                              currentSentence += ". " + query;
                            } else {
                              currentSentence = query;
                            }
                            //If the combined sentence contains less than 15 words, merge it with the next sentence
                            if (currentSentence.split(" ").length < 15) {
                              continue;
                            }
                            queries.add(currentSentence.trim());
                            currentSentence = "";
                          }
                          if (currentSentence.trim() != "")
                            queries.add(currentSentence);

                          queryData.updateQueries(queries);
                        });
                      },
                      label: Text(
                        'Search ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                      ),
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
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
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 13),
                          )),
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
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RecList(query: selectedQuery),
        SizedBox(height: 15,)
      ],
    );
  }
}

class RecList extends StatelessWidget {
  final String query;
  final ScrollController _scrollController = ScrollController();

  RecList({this.query});

  @override
  Widget build(BuildContext context) {
    UserQuery queryData = Provider.of<UserQuery>(context, listen: false);
    if (query == null || query == '') {
      return Container();
    }
    if (!queryData.recommendations.containsKey(query)) {
      return Loading();
    }
    Set<Recommendation> recs = queryData.recommendations[query];
    if (recs.isEmpty) {
      recs.addAll(List.generate(
          10,
          (index) => Recommendation(
              id: index + 1,
              paperId: 59225,
              url: 'http://google.com',
              title: 'Error retrieving recommendations, this is a test sample',
              authors: 'Isabela, Vinzenz & Sebastian',
              decisiveword: "recommend")));
    }

    return Expanded(
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
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
