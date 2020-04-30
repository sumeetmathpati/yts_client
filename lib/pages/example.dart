import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homeURL = "https://yts.mx/api/v2/list_movies.json?limit=20";
  //https://yts.mx/api/v2/list_movies.json?query_term=%22avengers%22

  var data;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchData(homeURL);
  }

  fetchData(String url) async {
    var res = await http.get(url);
    data = jsonDecode(res.body);
    print(data["status"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "yts client",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: data != null
          ? Container()
          : Center(child: CircularProgressIndicator()),
    );
  }
}
