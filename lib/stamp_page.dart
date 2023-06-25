import "package:flutter/material.dart";
import 'package:stamprally_v2/project_information_page.dart';

class StampPage extends StatefulWidget {
  const StampPage({super.key});

  @override
  State<StampPage> createState() => _StampPageState();
}

class _StampPageState extends State<StampPage> {
  var stamp_total = 5;
  static const genres = ["スタンプラリー", "スポット", "グルメ", "フォト"];
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(
            'images/appBarImage.png',
            height: 38,
          ),
        ),
        body: Column(
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
                  )

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final genre in genres)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:5),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(999999),border: Border.all(color: Colors.black54),),
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
                      ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                itemCount: 5,
                itemBuilder: (context, int position) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0, vertical:10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey, //色
                                  spreadRadius: 0,
                                  blurRadius: 3
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset("images/tile-test.png"),
                            ),
                            height: 90,
                            width: 90,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left:15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ここにタイトルが入る",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 7,),
                                        Text("場所:日本"),
                                        Text("期間:2022/12/12 ~ 2022/10/12"),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: true,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 1,),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            "ここに説明を入れるここに説明を入れるここに説明を入れるここに説明を入れるここに説明を入れるここに説明を入れる",
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProjectInformationPage()),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Divider(
                      height: 1,

                    ),
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}
