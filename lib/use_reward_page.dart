import 'package:flutter/material.dart';
import 'package:stamprally_v2/unused_reward_model.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UseRewardPage extends StatefulWidget {
  const UseRewardPage({super.key});

  @override
  State<UseRewardPage> createState() => _UseRewardPageState();
}

class _UseRewardPageState extends State<UseRewardPage> {
  List _useRewards = [];
  String appNum = '';
  @override
  void initState() {
    super.initState();
    Future(() async {

      _useRewards = await getData(
        '/get/user/unused_rewards',
        {
          'user_id': userId,
          'unused_reward_id' : Provider.of<UnusedRewardModel>(context, listen: false).unusedRewardInfo['id']
        }
      );

      appNum = _useRewards[0]['application_number'];
      setState(() {

      });
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
      body: Consumer<UnusedRewardModel>(
        builder: (context, model, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.unusedRewardInfo["title"] != null
                      ? model.unusedRewardInfo["title"]
                      : "...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                  SizedBox(height: 30,),
                  QrImageView(
                    data: appNum,
                    version: QrVersions.auto,
                    size: 300.0,
                  ),
                  Text(
                    appNum,
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}