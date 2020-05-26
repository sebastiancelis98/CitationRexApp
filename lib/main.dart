import 'dart:convert';
import 'dart:io';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Citation Rex'),
          backgroundColor: Colors.blueAccent,
        ),
        body: DynamicBody());
  }
}

class DynamicBody extends StatefulWidget {
  @override
  _DynamicBodyState createState() => _DynamicBodyState();
}

class Paper {
  String name;
  String alias;
  User(Map<String, dynamic> data) {
    name = data['name'];
    alias = data['alias'];
  }
}

class _DynamicBodyState extends State<DynamicBody> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(10),
          color: Colors.black12,
          child: TextField(
            maxLines: null,
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter the citation context here'),
          ),
        ),
        RaisedButton(
          onPressed: () {
            setState(() {});
          },
          child: Text('Search'),
        ),
        RecommendationList(query: controller.text)
      ],
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
    String query = '{"query": "${this.query}"}';

    print("Sending request to backend server...");
    try {
      Response response = await post(url, headers: headers, body: query);

      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return 'Error';
      }

      print(response.body);

      return response.body;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(query);
    if (query == null || query == '') {
      return Text('Enter something in the text field and hit search!');
    }
    return FutureBuilder(
      future: getRecommendations(),
      builder: (context, AsyncSnapshot<String> snap) {
        if (!snap.hasData) {
          //Still fetching the data or data is null, return a loading widget
          return CircularProgressIndicator();
        }

        String data = snap.data;
        //To test in case backend doesn't currently work
        //String data =            "{ \"papers\" : [ {\"id\": 1,\"title\": \"Image Classification with CNN\",   \"description\": \"Celis et al 2021 - ACM\" },  {\"id\": 2,  \"title\": \"Neural Citation Recommendation\", \"description\": \"Need to find a good Python tutorial on the web\" }]}";
        Map<String, dynamic> parseddata = json.decode(data);

        return Expanded(
          child: Scrollbar(
              isAlwaysShown: true,
              child: ListView.builder(
                  itemCount: parseddata['papers'].length,
                  itemBuilder: (context, i) {
                    var p = parseddata['papers'][i];
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
                  })),
        );
      },
    );
  }
}
