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
        title: 'Citation Rex',
        debugShowCheckedModeBanner: false,
        theme: Themes().lightTheme(),
        home: RootPage(),
      ),
    );
  }
}

class RootPage extends StatelessWidget {
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

  String _query;
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
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      ' Get useful citation recommendations for your scientific paper.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
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
                          //Get the list of current queries or an empty list if null
                          List<String> queries = List();
                          _query = _textController.text;

                          //Splits the input texts where new lines have been started
                          queries.addAll(_query.split("\n"));
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
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, i){
            return RecommendationTile(
              recommendation: Recommendation(
                  id: i,
                  title: 'Error retrieving recommendations, this is a test sample',
                  authors: 'Isabela, Vinzenz & Sebastian'),
            );
          },
        ),
      );
      return Container();
    }
    String selectedQuery = queries.elementAt(currentIndex);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Opacity(
                opacity: currentIndex != 0 ? 1 : 0.5,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).buttonColor,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
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
                      child: Text(selectedQuery)),
                ),
              ),
              Opacity(
                opacity: currentIndex < queries.length - 1 ? 1 : 0.5,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).buttonColor,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: Colors.white),
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
        ),
        SizedBox(
          height: 25,
        ),
        RecList(query: selectedQuery)
      ],
    );
  }
}

class RecList extends StatelessWidget {
  final String query;

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
      recs.add(Recommendation(
          id: 1,
          title: 'Error retrieving recommendations, this is a test sample',
          authors: 'Isabela, Vinzenz & Sebastian'));
    }

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Scrollbar(
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
