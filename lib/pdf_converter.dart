// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

class PdfPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  PdfPage({Key? key}) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  // ignore: prefer_typing_uninitialized_variables
  var data;

  List listData = [];
  bool res = false;
  File? newFile;
  var lang = 0;
  String fileName = '';
  String filePath = '';
  int fileSize = 0;
  var weburl = '';
  bool websiteCame = false;

  Future getData(text) async {
    var url = "http://api.rest7.com/v1/pdf_to_text.php?layout=0";

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', text));
    var res = await request.send();
    // ignore: duplicate_ignore
    if (res.statusCode == 200) {
      // ignore: avoid_print
      print(res.headers);
      // ignore: avoid_print
      print('Uploaded!');
    } else {
      print('Failed!');
    }
    final responsed = await http.Response.fromStream(res);
    final responseData = json.decode(responsed.body);
    print(responseData);
    // print(response.body);
    // data = json.decode(response.body);
    // print(data);
    Map<String, dynamic> map = responseData;
    // map.values.forEach((value) {
    //   print(value);
    // });
    map.forEach((key, value) {
      if (key == 'file') {
        getUrl(value);
      }
      print('Key = $key : Value = $value');
    });
  }

  String getUrl(url) {
    weburl = url;
    return weburl;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    void openFile(PlatformFile file) {
      OpenFile.open(file.path!);
    }

    print(filePath);
    print('check--------------------------');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result == null) return;
                    final file = result.files.first;
                    setState(() {
                      weburl = '';
                      websiteCame = false;
                      fileName = file.name;
                      filePath = file.path.toString();
                    });
                    newFile = await savePermantently(file);
                  },
                  child: const Text('Pick Pdf File'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    getData(filePath);
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(fileName),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              onPressed: () {
                // setState(() {
                //   Text(weburl);
                // });
                // Text(weburl);
                setState(() {
                  Text(weburl);
                  websiteCame = true;
                });
              },
              child: const Text('Convert PDF'),
            ),
          ),

          // Text(
          //   weburl,
          // ),
          // ignore: sized_box_for_whitespace
          Container(
            height: 350.0,
            child: websiteCame
                ? WebView(
                    initialUrl: weburl,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Future<File> savePermantently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();

    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }
}
