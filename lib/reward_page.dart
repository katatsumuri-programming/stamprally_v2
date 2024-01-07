import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stamprally_v2/reward_model.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
class RewardPage extends StatefulWidget {
  // final Map<String, dynamic> rewardData;

  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  late Map<String, dynamic> rewardData = {};
  late List _isObtainable = [];
  late List _userRewardData = [];
  Map _rewardInfo = {};

  @override
  void initState() {
    super.initState();
    Future(() async {
      _rewardInfo = Provider.of<RewardModel>(context, listen: false).rewardInfo;

      _isObtainable = await getData('/get/user/rewards/is_obtainable', {'user_id':userId, 'reward_id':_rewardInfo['id']});

      print(_isObtainable);
      if (_isObtainable.length == 1 && _isObtainable[0]['obtainable'] == 'true') {
        Provider.of<RewardModel>(context, listen: false).updateIsObtainable(true);
      } else if (_userRewardData.length == 0) {
        Provider.of<RewardModel>(context, listen: false).updateIsObtainable(false);
      }
      setState(() {});
    });


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
      ),
      body: Consumer<RewardModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                model.imageUrl != null
                  ? Image(image: CachedNetworkImageProvider(model.imageUrl))
                  : const Center(child:CircularProgressIndicator()),
                SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.rewardInfo["title"] != null
                          ? model.rewardInfo["title"]
                          : "...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          model.rewardInfo["explanation"] != null
                            ? model.rewardInfo["explanation"]
                            : "...",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:5),
                              child: Text(
                                '申し込む',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: !model.isObtainable ? null : () async {
                              await postData('/post/rewards/apply', {'user_id':userId, 'reward_id':_rewardInfo['id']});

                              var infoBox = Hive.box('info_cache');
                              await infoBox.delete(getPendingUri('/get/user/available_rewards_list', {'user_id':userId}).toString());
                              await infoBox.delete(getPendingUri('/get/user/unused_rewards_list', {'user_id':userId}).toString());

                              model.updateIsObtainable(false);
                              setState(() {});
                            },
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}