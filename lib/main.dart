import 'package:flutter/material.dart';

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
          title: Text('CitationRex'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
      children: <Widget>[
        Expanded(
          child: Text('welcome to the Citation Recommendation demo'),
        ),
        TextField(
        decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Enter the citation context here'
        ),
        ),
        const SizedBox(height: 30),
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
      onPressed: () {
        
        print("ohhimarkus");
        if (buttontext=="GO"){
          buttontext="HI";
        }
        else {
          buttontext="GO";
        }
        setState(() {
          
        });

        
        
        },
    );
  }
}