import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
        title: !isSearching
            ? Text("yts client")
            : TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search movie names",
                ),
                onSubmitted: (text) {
                  setState(() {
                    fetchData(
                        "https://yts.mx/api/v2/list_movies.json?query_term=${text}");
                  });
                },
              ),
        elevation: 0,
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
          ? Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: data["data"]["movie_count"] > 0
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          child: ListTile(
                            title: Text(
                                data["data"]["movies"][index]["title_long"]),
                            subtitle: Text(
                                "Year: ${data["data"]["movies"][index]["year"]}"),
                            leading: Image.network(data["data"]["movies"][index]
                                ["medium_cover_image"]),
                          ),
                        );
                      },
                      itemCount:
                          data["data"]["movie_count"] < data["data"]["limit"]
                              ? data["data"]["movie_count"]
                              : data["data"]["limit"],
                    )
                  : Center(
                      child: Text("No result found"),
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
