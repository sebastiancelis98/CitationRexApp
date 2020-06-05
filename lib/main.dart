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
            margin: EdgeInsets.only(right: 150),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: HexColor.fromHex('4A6B8A')),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            ),
            child: TextField(
              maxLines: 10,
              controller: _textController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
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
          SizedBox(
            height: 25,
          ),
          Center(child: RecommendationList(query: _query),),
          SizedBox(
            height: 25,
          ),
          
        ],
      ),
    );
  }
}

Map<String, Set<Recommendation>> _recsMap = Map();

class QuerySelector extends StatefulWidget {
  final List<String> queries;

  QuerySelector({this.queries});

  @override
  _QuerySelectorState createState() => _QuerySelectorState();
}

class _QuerySelectorState extends State<QuerySelector> {
  String selectedQuery;

  @mustCallSuper
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.queries == null || widget.queries.isEmpty){
      return Text('queries empty');
    }
    selectedQuery = widget.queries.first;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FloatingActionButton(onPressed: (){}, child: Icon(Icons.keyboard_arrow_left),),
            Text(selectedQuery ?? 'Some query...'),
            FloatingActionButton(onPressed: (){}, child: Icon(Icons.keyboard_arrow_right),),
            
          ],
        ),
        Center(
          child: RecList(recs: _recsMap.containsKey(selectedQuery) ? _recsMap[selectedQuery]:null),
        )
      ],
    );
  }
}

class RecList extends StatefulWidget {

  final Set<Recommendation> recs;

  RecList({this.recs});

  @override
  _RecListState createState() => _RecListState();
}

class _RecListState extends State<RecList> {
  @override
  Widget build(BuildContext context) {
    if(widget.recs == null || widget.recs.isEmpty){
      return Loading();
    }
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.recs.length,
      itemBuilder: (context, i) {
        return RecommendationTile(
          recommendation: widget.recs.elementAt(i),
        );
      },
    );
  }
}

class RecommendationList extends StatefulWidget {
  final String query;

  RecommendationList({@required this.query});

  @override
  _RecommendationListState createState() => _RecommendationListState();
}

class _RecommendationListState extends State<RecommendationList> {
  @override
  Widget build(BuildContext context) {
    if (widget.query == null || widget.query == '') {
      //return Text('Enter your citation context and hit search!');
      return Container();
    }
    if (!_recsMap.containsKey(widget.query)) {
      getRecommendations(this.widget.query).then((value) => {
            setState(() {
              _recsMap.putIfAbsent(widget.query, () => value);
            })
          });
      return Loading();
    }

    Set recs = _recsMap[widget.query];
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
  }
}
