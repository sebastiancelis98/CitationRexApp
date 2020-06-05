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
    return MaterialApp(
      title: 'Citation Rex',
      debugShowCheckedModeBanner: false,
      theme: Themes().lightTheme(),
      home: RootPage(),
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

  @override
  Widget build(BuildContext context) {
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
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
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
                  setState(() {
                    _query = _textController.text;
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
              child: ChangeNotifierProvider<UserQuery>.value(
                  value: UserQuery(queries: [
                    _query,
                    //'Neural Networks are really cool, especially if they are convolutional' //to test this feature out
                  ]),
                  child: QuerySelector()),
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
    print('Rebuilding queryselector...');
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                if (currentIndex != 0) {
                  setState(() {
                    currentIndex--;
                  });
                }
              },
              child: Icon(Icons.keyboard_arrow_left),
            ),
            Text(selectedQuery ??
                'Enter a sentence in the text field and hit search...'),
            FloatingActionButton(
              onPressed: () {
                if (currentIndex < queries.length - 1) {
                  setState(() {
                    currentIndex++;
                  });
                }
              },
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ],
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
