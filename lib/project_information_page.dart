import 'package:flutter/material.dart';
import 'package:stamprally_v2/spot_information_page.dart';
import 'package:stamprally_v2/my_rewards_page.dart';

class ProjectInformationPage extends StatefulWidget {
  const ProjectInformationPage({super.key});

  @override
  State<ProjectInformationPage> createState() => _ProjectInformationPageState();
}

class _ProjectInformationPageState extends State<ProjectInformationPage> {

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
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(child: Text("概要")),
              Tab(child: Text("スポット")),
              Tab(child: Text("マップ")),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            OverviewTabView(),
            CheckPointTabView(),
            MapTabView()
          ],
        ),
      ),
    );
  }
}

class OverviewTabView extends StatefulWidget {
  const OverviewTabView({super.key});

  @override
  State<OverviewTabView> createState() => _OverviewTabViewState();
}

class _OverviewTabViewState extends State<OverviewTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/hetumiya.jpg"),
              const SizedBox(height: 10,),
              Text(
                "ここにタイトルが入る",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                "開催期間: 2022/02/02 ~ 2023/02/02",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 3,),
              Text(
                "開催場所: 神奈川県",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 7,),
              const Text(
                "概要",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Column(
                  children: [
                    const SizedBox(height: 4,),
                    Center(
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: const Text(
                            '参加',
                            style: TextStyle(
                              fontSize: 16,
                            )
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4,),
              const Text(
                "特典",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              MyRewardsList(),

              const Text(
                "URL",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("https://wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"),
              )

            ],
          ),
        ),
      ),
    );
  }
}
class CheckPointTabView extends StatefulWidget {
  const CheckPointTabView({super.key});

  @override
  State<CheckPointTabView> createState() => _CheckPointTabViewState();
}

class _CheckPointTabViewState extends State<CheckPointTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
class MapTabView extends StatefulWidget {
  const MapTabView({super.key});

  @override
  State<MapTabView> createState() => _MapTabViewState();
}

class _MapTabViewState extends State<MapTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(child:Text("ここにマップをのせる"), color: Colors.red,);
  }
}