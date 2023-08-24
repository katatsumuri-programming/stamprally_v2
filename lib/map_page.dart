import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stamprally_v2/main.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(
            'images/appBarImage.png',
            height: 38,
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: <Widget> [
              Tab(text: "すべて",),
              Tab(text: "スタンプカード",),
              Tab(text: "スタンプラリー",)
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            MapTopPage(),
            MapCardPage(),
            MapRallyPage(),
          ],
        ),
      ),

    );
  }
}

class MapTopPage extends StatefulWidget {
  const MapTopPage({super.key});

  @override
  State<MapTopPage> createState() => _MapTopPageState();
}

class _MapTopPageState extends State<MapTopPage> {
  static const genres = ["グルメ", "フォト"];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.red,
          child: Center(child: Text('ここにマップを入れる', style: TextStyle(fontSize: 20)))
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(10),
                  hintText: '検索',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.white,
                  filled: true,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10, right:10, bottom:10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final genre in genres)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:5),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999999),
                              border: Border.all(color: Colors.black54),
                              color: Colors.white
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:6, horizontal:15),
                              child: Text(
                                genre,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,

                                ),
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                  ],
                ),
              ),
            ),

          ],
        ),

      ]
    );
  }
}

class MapCardPage extends StatefulWidget {
  const MapCardPage({super.key});

  @override
  State<MapCardPage> createState() => _MapCardPageState();
}

class _MapCardPageState extends State<MapCardPage> {
  static const genres = ["グルメ", "フォト"];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.red,
          child: Center(child: Text('ここにマップを入れる', style: TextStyle(fontSize: 20)))
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(10),
                  hintText: '検索',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.white,
                  filled: true,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10, right:10, bottom:10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final genre in genres)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:5),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999999),
                              border: Border.all(color: Colors.black54),
                              color: Colors.white
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:6, horizontal:15),
                              child: Text(
                                genre,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]
    );
  }
}

class MapRallyPage extends StatefulWidget {
  const MapRallyPage({super.key});

  @override
  State<MapRallyPage> createState() => _MapRallyPageState();
}

class _MapRallyPageState extends State<MapRallyPage> {
  static const genres = ["なんかスタンプラリーの名前", "なんかスタンプラリーの名前"];
  String test_txt = "";


    @override
  void initState() {
    super.initState();
    Future(() async {
      var spots_info = await getData('get_spots_info', '1');
      print(spots_info);
    });


    // _getData();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.red,
          child: Center(child: Text(test_txt, style: TextStyle(fontSize: 20)))
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(10),
                  hintText: '検索',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.white,
                  filled: true
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10, right:10, bottom:10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final genre in genres)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:5),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999999),
                              border: Border.all(color: Colors.black54),
                              color: Colors.white
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:6, horizontal:15),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 220,
                                ),
                                child: Text(
                                  genre,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}