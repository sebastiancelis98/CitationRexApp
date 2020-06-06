import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:CitationRexWebsite/model/userquery.dart';
import 'package:CitationRexWebsite/utils/color.dart';
import 'package:CitationRexWebsite/utils/customwidgets.dart';
import 'package:CitationRexWebsite/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/recommender.dart';

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
    return Scaffold(body: DynamicBody());
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'CitationRex',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Theme.of(context).primaryColor,
                      fontSize: 55,
                    ),
                  ),
                  Text(
                    ' Get useful citation recommendations for your scientific paper.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 45 / 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: HexColor.fromHex('4A6B8A')),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: TextField(
                maxLines: 20,
                controller: _textController,
                style: TextStyle(fontSize: 13, fontFamily: 'Montserrat'),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    errorText: _errorText,
                    hintText: 'Enter the citation context here...'),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: HexColor.fromHex('54A759'),
                elevation: 1,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                onPressed: () {
                  if (_textController.text.length < 10) {
                    //Temporary break condition TODO 15 words min.
                    setState(() {
                      _errorText =
                          'Please enter a sentence with 10 or more characters!';
                    });
                    return;
                  }
                  setState(() {
                    
                    //Get the list of current queries or an empty list if null
                    List<String> queries = queryData.queries ?? List();

                    _query = _textController.text;
                    
                    //Splits the input texts where new lines have been started
                    
                    queries.addAll(_query.split("\n"));
                    queryData.updateQueries(queries);

                    /*
                    queryData.updateQueries([
                      _query,
                      'Neural networks are really cool, especially if they are convolutional'
                    ]);
                    */
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
          child: Container(
            margin: EdgeInsets.only(top: 25),
            color: Colors.transparent,
            child: Center(
              child: QuerySelector(),
            ),
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
                opacity: currentIndex < queries.length -1 ? 1 : 0.5,
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
    Set recs = queryData.recommendations[query];
    return Expanded(
      child: Container(
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
      ),
    );
  }
}
