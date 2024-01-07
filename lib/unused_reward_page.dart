import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stamprally_v2/unused_reward_model.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/main.dart';
import 'package:stamprally_v2/use_reward_page.dart';

class UnusedRewardPage extends StatefulWidget {

  const UnusedRewardPage({super.key});

  @override
  State<UnusedRewardPage> createState() => _UnusedRewardPageState();
}

class _UnusedRewardPageState extends State<UnusedRewardPage> {

  @override
  void initState() {
    super.initState();


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
      body: Consumer<UnusedRewardModel>(builder: (context, model, child) {
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
                        model.unusedRewardInfo["title"] != null
                          ? model.unusedRewardInfo["title"]
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
                          model.unusedRewardInfo["explanation"] != null
                            ? model.unusedRewardInfo["explanation"]
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
                                '利用する',
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
                            onPressed: () {
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) => UseRewardPage(),
                                  //以下を追加
                                  fullscreenDialog: true,
                                )
                              );
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