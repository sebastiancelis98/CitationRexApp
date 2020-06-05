import 'package:CitationRexWebsite/model/recommendation.dart';
import 'package:CitationRexWebsite/utils/color.dart';
import 'package:CitationRexWebsite/utils/customwidgets.dart';
import 'package:CitationRexWebsite/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool _newSearch;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.all(15),
            child: Column(
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
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(4),
            child: TextField(
              maxLines: 10,
              controller: _textController,
              decoration: InputDecoration(
                  fillColor: Colors.black12,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor.fromHex('4A6B8A')),
                      borderRadius: BorderRadius.circular(20)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).secondaryHeaderColor),
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Enter the citation context here...'),
            ),
          ),
          Center(
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: HexColor.fromHex('54A759'),
              elevation: 1,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              onPressed: () {
                setState(() {
                  _newSearch = _query != _textController.text;
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
          SizedBox(
            height: 25,
          ),
          Center(
            child: RecommendationList(
              query: _query,
              newSearch: _newSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationList extends StatefulWidget {
  final String query;
  final bool newSearch;

  RecommendationList({this.query, this.newSearch});

  @override
  _RecommendationListState createState() => _RecommendationListState();
}

class _RecommendationListState extends State<RecommendationList> {
  Map<String, Set<Recommendation>> recsMap = Map();

  @override
  Widget build(BuildContext context) {
    if (widget.query == null || widget.query == '') {
      //return Text('Enter your citation context and hit search!');
      return Container();
    }
    if (!recsMap.containsKey(widget.query)) {
      getRecommendations(this.widget.query).then((value) => {
            setState(() {
              recsMap.putIfAbsent(widget.query, () => value);
            })
          });
      return Loading();
    }
    Set recs = recsMap[widget.query];
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: recs.length,
      itemBuilder: (context, i) {
        return RecommendationTile(
          recommendation: recs.elementAt(i),
        );
      },
    );

    return FutureBuilder(
      future: getRecommendations(this.widget.query),
      initialData: null,
      builder: (context, AsyncSnapshot<Set<Recommendation>> snap) {
        print(snap.data);
        if (!snap.hasData) {
          //Still fetching the data or data is null, return a loading widget
          return Loading();
        }

        Set<Recommendation> recs = snap.data;

        return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: recs.length,
            itemBuilder: (context, i) {
              return RecommendationTile(recommendation: recs.elementAt(i));
            });
      },
    );
  }
}
