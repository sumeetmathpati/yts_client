import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ytsclient/pages/movie_details.dart';

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
            ? Text(
                "yts client",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              )
            : TextField(
                style: TextStyle(color: Colors.blueAccent),
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
            icon: Icon(
              Icons.search,
              color: Colors.blueAccent,
            ),
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
                color: Colors.white,
              ),
              child: data["data"]["movie_count"] > 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6667,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                        
                          // margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: InkWell(
                          
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MovieDetails(
                                          data["data"]["movies"][index]
                                              ["id"])));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data["data"]["movies"][index]
                                    ["large_cover_image"],
                                fit: BoxFit.cover,
                              ),
                            ),
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
              child: Container(child: CircularProgressIndicator()),
            ),
    );
  }
}
