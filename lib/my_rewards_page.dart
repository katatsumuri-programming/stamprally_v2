import 'package:flutter/material.dart';
import 'package:stamprally_v2/rewards_list_model.dart';
import 'package:stamprally_v2/unused_reward_model.dart';
import 'package:stamprally_v2/unused_reward_page.dart';
import 'reward_page.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stamprally_v2/reward_model.dart';
import 'package:stamprally_v2/main.dart';
class MyRewardsPage extends StatefulWidget {
  const MyRewardsPage({super.key});

  @override
  State<MyRewardsPage> createState() => _MyRewardsPageState();
}

class _MyRewardsPageState extends State<MyRewardsPage> with SingleTickerProviderStateMixin{
  TabController? _tabController;


  List _rewardsListAvailable = [];
  List _availableImages = [];
  List _rewardsListUnused = [];
  List _unusedImages = [];
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController!.addListener(() {
      Provider.of<RewardsListModel>(context, listen: false).changedPage(_tabController!.index);
      // if (_tabController!.index == 0) {
      //   Provider.of<RewardsListModel>(context, listen: false).updateIsUnusedRewardsPage(true);
      //   // Provider.of<RewardsListModel>(context, listen: false).updateRewardList(_rewardsListUnused);
      //   // Provider.of<RewardsListModel>(context, listen: false).updateImageUrlList(_unusedImages);
      // } else if (_tabController!.index == 1) {
      //   Provider.of<RewardsListModel>(context, listen: false).updateIsUnusedRewardsPage(false);
      //   // Provider.of<RewardsListModel>(context, listen: false).updateRewardList(_rewardsListAvailable);
      //   // Provider.of<RewardsListModel>(context, listen: false).updateImageUrlList(_availableImages);
      // }
      setState(() {});
    });
    Future(() async {
      _rewardsListAvailable = await getData('/get/user/available_rewards_list', {'user_id':userId});
      _rewardsListUnused = await getData('/get/user/unused_rewards_list', {'user_id':userId});
      for (var i = 0; i < _rewardsListAvailable.length; i++) {
        _availableImages.add(await getImageUrl(_rewardsListAvailable[i]['image']));
      }
      for (var i = 0; i < _rewardsListUnused.length; i++) {
        _unusedImages.add(await getImageUrl(_rewardsListUnused[i]['image']));
      }

      Provider.of<RewardsListModel>(context, listen: false).updateRewardsListUnused(_rewardsListUnused);
      Provider.of<RewardsListModel>(context, listen: false).updateRewardsListAvailable(_rewardsListAvailable);
      Provider.of<RewardsListModel>(context, listen: false).updateImageUnusedRewardsUrlList(_unusedImages);
      Provider.of<RewardsListModel>(context, listen: false).updateImageAvailableRewardsUrlList(_availableImages);
      Provider.of<RewardsListModel>(context, listen: false).changedPage(0);
      Provider.of<RewardsListModel>(context, listen: false).updateFromMyRewardsPage(true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: <Widget> [
            Tab(text: "未使用特典",),
            Tab(text: "受け取り可能特典",)
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          RewardsList(),
          RewardsList()
        ],
      ),
    );
  }
}


class RewardsList extends StatefulWidget {

  const RewardsList({super.key});

  @override
  State<RewardsList> createState() => _RewardsListState();
}

class _RewardsListState extends State<RewardsList> {


  @override
  Widget build(BuildContext context) {
    return Consumer<RewardsListModel>(builder: (context, model, child) {

      return Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model.rewardsList.length,
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical:6),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
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
                          child: model.imageUrlList.length > 0
                            ? FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Image(image: CachedNetworkImageProvider(model.imageUrlList[index]))
                            )
                            : const Center(child:CircularProgressIndicator())
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
                                model.rewardsList[index]["title"] != null
                                  ? model.rewardsList[index]["title"]
                                  : "...",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 1,),
                              Text(
                                model.rewardsList[index]["conditions"] != null
                                  ? model.rewardsList[index]["application_number"] == null ? "応募条件: スタンプ" + model.rewardsList[index]["conditions"].toString() + '個以上'
                                  : "期限: " + model.rewardsList[index]["conditions"].toString()
                                  : "...",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  model.rewardsList[index]["explanation"] != null
                                    ? model.rewardsList[index]["explanation"]
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
                onTap: () async {
                  if (model.rewardsList[index]['application_number'] == null) { //利用可能
                    Provider.of<RewardModel>(context, listen: false).updateRewardInfo(model.rewardsList[index]);
                    Provider.of<RewardModel>(context, listen: false).updateImageUrl(model.imageUrlList[index]);
                    await Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => RewardPage(),
                        //以下を追加
                        fullscreenDialog: true,
                      )
                    );
                  } else { //未使用
                    Provider.of<UnusedRewardModel>(context, listen: false).updateUnusedRewardInfo(model.rewardsList[index]);
                    Provider.of<UnusedRewardModel>(context, listen: false).updateImageUrl(model.imageUrlList[index]);
                    await Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => UnusedRewardPage(),
                        //以下を追加
                        fullscreenDialog: true,
                      )
                    );
                  }
                  if (model.fromMyRewardsPage) {
                    List availableImages = [];
                    List unusedImages = [];
                    List rewardsListAvailable = await getData('/get/user/available_rewards_list', {'user_id':userId});
                    List rewardsListUnused = await getData('/get/user/unused_rewards_list', {'user_id':userId});
                    for (var i = 0; i < rewardsListAvailable.length; i++) {
                      availableImages.add(await getImageUrl(rewardsListAvailable[i]['image']));
                    }
                    for (var i = 0; i < rewardsListUnused.length; i++) {
                      unusedImages.add(await getImageUrl(rewardsListUnused[i]['image']));
                    }

                    model.updateRewardsListUnused(rewardsListUnused);
                    model.updateRewardsListAvailable(rewardsListAvailable);
                    model.updateImageUnusedRewardsUrlList(unusedImages);
                    model.updateImageAvailableRewardsUrlList(availableImages);
                    model.changedPage(
                      model.pageNumber
                    );
                  }
                  setState(() {

                  });
                },
              ),
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
    });
  }
}


