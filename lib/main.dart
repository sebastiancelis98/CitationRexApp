import 'dart:io';

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(10),
              color: Colors.black12,
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter the citation context here'),
              ),
            ),
            RaisedButton(
              onPressed: () async {
                print('Sending request...');
                String url = 'https://jsonplaceholder.typicode.com/posts/1';
                Map<String, String> headers = {
                  "Content-type": "application/json"
                };
                String json =
                    '{"title": "Hello", "body": "body text", "userId": 1}';
                // make PUT request
                Response response =
                    await put(url, headers: headers, body: json);
                // check the status code for the result
                int statusCode = response.statusCode;

                print(statusCode);
                print(response.body);
              },
              child: Text('Search'),
            ),
            MyButton(),
          ],
        ));
  }
}

class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  String buttontext = "GO";
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(buttontext),
      onPressed: () async {
        if (buttontext == "GO") {
          buttontext = "HI";
        } else {
          buttontext = "GO";

          //Neue Erinnerung
        }
        setState(() {});

        String url = 'http://aifb-ls3-vm1.aifb.kit.edu:5000/api/recommendation';
        Map<String, String> headers = {
          "Content-type": "application/json",
        };
        String json = '{"title": "Hello", "body": "body text", "userId": 1}';

        Response response = await post(url, headers: headers, body: json);

        int statusCode = response.statusCode;
        setState(() {
          buttontext = 'Code ' + statusCode.toString();
        });

        print(response.body);
      },
    );
  }
}
