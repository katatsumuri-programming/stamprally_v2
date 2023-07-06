import 'package:flutter/material.dart';
import 'package:stamprally_v2/main.dart';
import 'package:stamprally_v2/rewards_model.dart';
import 'package:stamprally_v2/spot_information_page.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:stamprally_v2/my_rewards_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stamprally_v2/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/project_information_page_mdoel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProjectInformationPage extends StatefulWidget {
  const ProjectInformationPage({super.key});

  @override
  State<ProjectInformationPage> createState() => _ProjectInformationPageState();
}

class _ProjectInformationPageState extends State<ProjectInformationPage> {

  late FirebaseStorage _storage;
  late FirebaseFirestore _firestore;
  late String _imageUrl = "";
  late ProjectInformationPageModel projectInformationPageModel;
  late RewardsModel rewardsModel;
  late SpotInformationModel spotInformationModel;
  Map<String, dynamic> stamprally_info = {};


  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Firebase Storageのインスタンスを初期化
    _storage = FirebaseStorage.instance;
    _firestore = FirebaseFirestore.instance;
    projectInformationPageModel = Provider.of<ProjectInformationPageModel>(context, listen: false);
    rewardsModel = Provider.of<RewardsModel>(context, listen: false);
    spotInformationModel = Provider.of<SpotInformationModel>(context, listen: false);
    // 画像のダウンロードURLを取得
    _getData();
  }


  Future<void> _getData() async {
    DocumentSnapshot snapshot = await _firestore.collection('StampRallies').doc('pPAHgq72tzGZGsMDz2Vr').get();
    // print(snapshot.data());

    projectInformationPageModel.updateStamprallyInfo(snapshot.data() as Map<String, dynamic>);

    String downloadUrl = await _storage.ref().child(projectInformationPageModel.stamprallyInfo["images"][0]).getDownloadURL();
    projectInformationPageModel.updateImageUrl(downloadUrl);

    rewardsModel.updateRewardList(await getRewards(projectInformationPageModel.stamprallyInfo["rewards"], _firestore, _storage));
    spotInformationModel.updateSpotsList(await getSpots(projectInformationPageModel.stamprallyInfo["spots"], _firestore, _storage));
    spotInformationModel.updateReviewsList(await getReviews(spotInformationModel.spotsList, _firestore));
  }
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
          child: Consumer<ProjectInformationPageModel>(builder: (context, model, child) {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                model.imageUrl != ""
                  ? Image(image: CachedNetworkImageProvider(model.imageUrl))
                  : const Center(child:CircularProgressIndicator()),
                const SizedBox(height: 10,),
                Text(
                  model.stamprallyInfo["title"] != null
                    ? model.stamprallyInfo["title"]
                    : "...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  model.stamprallyInfo["period"] != null
                    ? "開催期間: " + model.stamprallyInfo["period"]
                    : "開催期間: ...",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 3,),
                Text(
                  model.stamprallyInfo["venue"] != null
                    ? "開催場所: " + model.stamprallyInfo["venue"]
                    : "開催場所: ...",
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
                    model.stamprallyInfo["explanation"] != null
                      ? model.stamprallyInfo["explanation"]
                      : "...",
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
                  child: Text(
                    model.stamprallyInfo["website"] != null
                      ? model.stamprallyInfo["website"]
                      : "...",
                  ),
                )

              ],
            );
          }),
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
    return Consumer<SpotInformationModel>(builder: (context, model, child) {

        return Container(
          child: ListView.separated(
            itemCount: model.spotsList.length,
            itemBuilder: (context, int index) {
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
                                model.spotsList[index]["name"] != null
                                  ? model.spotsList[index]["name"]
                                  : "...",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 1,),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  model.spotsList[index]["explanation"] != null
                                    ? model.spotsList[index]["explanation"]
                                    : "...",
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
                      builder: (context) => SpotInformationPage(spotInfo:model.spotsList[index], reviewsList:model.reviewsList[index] ),
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