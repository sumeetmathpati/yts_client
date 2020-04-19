import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homeURL =
      "https://yts.mx/api/v2/list_movies.json?limit=10?sort_by=year?order_by=asc";
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
        title: !isSearching
            ? Text("yts client")
            : TextField(
                decoration: InputDecoration(
                  hintText: "Search movie names",
                  icon: Icon(Icons.movie),
                ),
                onSubmitted: (text) {
                  setState(() {
                    fetchData("https://yts.mx/api/v2/list_movies.json?query_term=${text}");
                  });

                },
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                this.isSearching = !isSearching;
              });
            },
          )
        ],
      ),
      body: data != null
          ? Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(data["data"]["movies"][index]["title_long"]),
                        subtitle: Text(
                            "Year: ${data["data"]["movies"][index]["year"]}"),
                        leading: Image.network(data["data"]["movies"][index]
                            ["medium_cover_image"]),
                      );
                    },
                    itemCount: data["data"]["movie_count"],
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
