import 'package:flutter/material.dart';
import 'spot_information_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'images/appBarImage.png',
          height: 38,
        ),
      ),
      body: Container(
      child: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, int position) {
          return InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:15, vertical:7),
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
                    height: 80,
                    width: 80,
                  ),
                  Flexible(
                    child: Container(
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
                  )
                ]
              ),
            ),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => SpotInformationPage(),
                  //以下を追加
                  fullscreenDialog: true,
                )
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
    )
    );
  }
}