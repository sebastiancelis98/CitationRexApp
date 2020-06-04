import 'dart:convert';
import 'dart:io';

import 'package:CitationRexWebsite/utils/color.dart';
import 'package:CitationRexWebsite/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

class Paper {
  String name;
  String alias;
  Paper(Map<String, dynamic> data) {
    name = data['name'];
    alias = data['alias'];
  }
}

class _DynamicBodyState extends State<DynamicBody> {
  TextEditingController _textController = TextEditingController();
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
                setState(() {});
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
          SizedBox(height: 15,),
          Center(child: RecommendationList(query: _textController.text))
        ],
      ),
    );
  }
}

class RecommendationList extends StatelessWidget {
  final String query;

  RecommendationList({this.query});

  Future<String> getRecommendations() async {
    String url = 'http://aifb-ls3-vm1.aifb.kit.edu:5000/api/recommendation';

    Map<String, String> headers = {
      "Content-type": "application/json",
    };
    String json = '{"query": "${this.query}"}';

    print("Sending request to backend server...");
    try {
      Response response = await post(url, headers: headers, body: json);

      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return 'Error';
      }

      print(response.body);

      return response.body;
    } catch (e) {
      print(e);
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(query);
    if (query == null || query == '') {
      //return Text('Enter your citation context and hit search!');
      return Container();
    }
    
    return FutureBuilder(
      future: getRecommendations(),
      builder: (context, AsyncSnapshot<String> snap) {
        if (!snap.hasData) {
          //Still fetching the data or data is null, return a loading widget
          return CircularProgressIndicator();
        }

        String data = snap.data;
        if (data == 'Error') {
          return Text('Error connecting to the server...');
        }
        //To test in case backend doesn't currently work
        //String data =            "{ \"papers\" : [ {\"id\": 1,\"title\": \"Image Classification with CNN\",   \"description\": \"Celis et al 2021 - ACM\" },  {\"id\": 2,  \"title\": \"Neural Citation Recommendation\", \"description\": \"Need to find a good Python tutorial on the web\" }]}";
        dynamic parseddata = json.decode(data);

        print(parseddata);
        return Container();

        return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,//parseddata['papers'].length,
            itemBuilder: (context, i) {
              var p = parseddata['papers'][1];
              return Card(
                child: ListTile(
                    onTap: () {},
                    title: Text(p["title"]),
                    subtitle: Text(p["description"]),
                    leading: CircleAvatar(
                      child: Text((i + 1).toString(),
                          style: TextStyle(color: Colors.black)),
                      backgroundColor: Colors.transparent,
                    ),
                    trailing: Icon(Icons.archive)),
              );
            });
      },
    );
  }
}
