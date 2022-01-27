// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:task11/webview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//wait kru call haa kn
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  //static const routeName = '/home-screen ';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var data;
  bool res = false;
  // ignore: prefer_typing_uninitialized_variables
  var userData;
  // ignore: prefer_typing_uninitialized_variables
  var valueChoose;
  List listItem = ['en', 'pl', 'fr', 'de', 'it', 'es'];
  // ignore: non_constant_identifier_names
  String SearchText = '';
  List listData = [];

  //int _currentIndex = 0;

  Future getData(text, lang) async {
    http.Response response = await http.get(Uri.parse(
        "http://api.rest7.com/v1/wikipedia_search.php?text=${text}&language=${lang}"));
    data = json.decode(response.body);

    for (var k in data.keys) {
      listData.add(k);
    }
    setState(() {
      res = true;
    });
    // ignore: avoid_print
    print(listData);
  }

  //final Screen = [
  //  MyHomePage(),
  //  PdfPage(),
  //];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // ignore: duplicate_ignore
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text('TExtForm'),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
          
            Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.all(15.0),
              child: SizedBox(
                child: TextField(
                  onChanged: (text) {
                    SearchText = text;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter keyword',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ),
            ),
            DropdownButton(
              hint: Text('Select Language : '),
              value: valueChoose,
              onChanged: (newValue) {
                setState(() {
                  valueChoose = newValue.toString();
                });
              },
              items: listItem.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: () {
                  getData(SearchText, valueChoose);
                },
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(),
                )),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: res
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                /*print(index.toString());*/
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WebViewPage(
                                    websiteUrl: listData[index],
                                  ),
                                ));
                              },
                              title: Text(
                                listData[index],
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          );

                          /*return(
                      Text(listData[index])
                      );*/
                        },
                        itemCount: (listData.length - 1),
                      )
                    : Text('Enter any data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.all(Radius.circular(12.0)),
borderSide: BorderSide(color: Colors.red, width: 2),
),*/
