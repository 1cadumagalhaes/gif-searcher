import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _limit = 20, _offset=0;
  String _search;
  
  Future<Map>_getGifs() async{
    http.Response response;

    if(_search==null)
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=lU9HVg3Sm8akDCkE0eGn8vkGjadUNHOo&limit=${_limit.toString()}&rating=G");
    else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=lU9HVg3Sm8akDCkE0eGn8vkGjadUNHOo&q=${_search}&limit=${_limit.toString()}&offset=${_offset.toString()}&rating=G&lang=en");

    return json.decode(response.body);
  }


  @override
  void initState(){
    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
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
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center
            )
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context,snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  default:
                }
              },  
            ),
          )
        ],
      ),
    );
  }
}