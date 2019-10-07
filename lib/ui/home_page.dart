import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_searcher/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _limit = 19, _offset = 0;
  String _search;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=lU9HVg3Sm8akDCkE0eGn8vkGjadUNHOo&limit=$_limit.toString()&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=lU9HVg3Sm8akDCkE0eGn8vkGjadUNHOo&q=$_search&limit=$_limit.toString()&offset=$_offset.toString()&rating=G&lang=en");

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise Aqui",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  setState(() {
                    _offset = 0;
                    _search = text;
                  });
                },
              )),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else
      return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              placeholder: kTransparentImage,
              height: 300,
              fit: BoxFit.fill,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(
                  snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
              onLongPress: () {
                Share.share(
                    snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            ),
          );
        }
      },
    );
  }
}
