import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetails extends StatefulWidget {
  MovieDetails(this.movieID);

  final int movieID;

  @override
  _MovieDetailsState createState() => _MovieDetailsState(movieID);
}

class _MovieDetailsState extends State<MovieDetails> {
  _MovieDetailsState(this.movieID);

  String detailsURL = "https://yts.mx/api/v2/movie_details.json?movie_id=";
  var data;

  String title = " ";
  final int movieID;
  List<dynamic> genres = [];
  List<dynamic> torrents = [];

  fetchDetails() async {
    var res = await http.get(detailsURL + movieID.toString());
    data = jsonDecode(res.body);
    print(data["status"]);
    genres = data["data"]["movie"]["genres"];
    torrents = data["data"]["movie"]["torrents"];
    title = data["data"]["movie"]["title"];
    setState(() {
      _buildGenreRowList();
      _buildTorrentRowList();
    });
  }

  List<Widget> _buildGenreRowList() {
    List<Widget> genreContainers = [];
    for (var genre in genres) {
      genreContainers.add(Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [Colors.orange, Colors.red])),
        child: Text(
          genre,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ));
    }
    return genreContainers;
  }

  List<Widget> _buildTorrentRowList() {
    List<Widget> torrentContainers = [];
    for (var torrent in torrents) {
      torrentContainers.add(
        Container(
          padding: EdgeInsets.all(8),
          child: OutlineButton(
            onPressed: () {
              _launchURL(torrent["url"]);
            },
            padding: EdgeInsets.all(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
            shape: StadiumBorder(),
            child: Column(
              children: <Widget>[
                Text(
                  torrent["quality"],
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  torrent["type"],
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return torrentContainers;
  }

  _launchURL(String url) async {
    print("OPENING");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: data != null
          ? SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            data["data"]["movie"]["medium_cover_image"],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          data["data"]["movie"]["title"].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          data["data"]["movie"]["year"].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(
                              "imdb",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              data["data"]["movie"]["rating"].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildGenreRowList(),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data["data"]["movie"]["description_intro"]
                                .toString(),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildTorrentRowList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Container(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                color: Colors.white,
              ),
            ),
    );
  }
}
