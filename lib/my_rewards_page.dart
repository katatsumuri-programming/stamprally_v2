import 'package:flutter/material.dart';
import 'reward_page.dart';

class MyRewardsPage extends StatefulWidget {
  const MyRewardsPage({super.key});

  @override
  State<MyRewardsPage> createState() => _MyRewardsPageState();
}

class _MyRewardsPageState extends State<MyRewardsPage> {
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
              Tab(text: "未使用特典",),
              Tab(text: "受け取り可能特典",),
              Tab(text: "使用済み特典",),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MyRewardsList(),
            MyRewardsList(),
            MyRewardsList(),
          ],
        ),
      ),
    );
  }
}


class MyRewardsList extends StatefulWidget {
  const MyRewardsList({super.key});

  @override
  State<MyRewardsList> createState() => _MyRewardsListState();
}

class _MyRewardsListState extends State<MyRewardsList> {
  @override
  Widget build(BuildContext context) {
    return             Container(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, int position) {
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:6),
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
                                      Text(
                                        "応募条件:スタンプ5個以上",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
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
                            builder: (context) => RewardPage(),
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

              );
  }
}