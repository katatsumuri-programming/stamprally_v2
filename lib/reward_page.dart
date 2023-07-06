import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RewardPage extends StatefulWidget {
  final Map<String, dynamic> rewardData;

  const RewardPage({Key? key, required this.rewardData}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  late Map<String, dynamic> rewardData = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      rewardData = widget.rewardData;
    });
    print(rewardData);

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            rewardData["imageUrl"] != null
              ? Image(image: CachedNetworkImageProvider(rewardData["imageUrl"]))
              : const Center(child:CircularProgressIndicator()),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rewardData["title"] != null
                      ? rewardData["title"]
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
                      rewardData["explanation"] != null
                        ? rewardData["explanation"]
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
                          child: const Text(
                            '申し込む',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
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
          ],
        ),
      ),
    );
  }
}