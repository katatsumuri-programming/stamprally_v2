import 'package:flutter/material.dart';
import 'spot_information_page.dart';
import 'package:stamprally_v2/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List _userHistory = [];
  List _images = [];
  void initState() {
    super.initState();
    Future(() async {
      _userHistory = await getData('/get/user/history', {'user_id':userId});

      for (var i = 0; i < _userHistory.length; i++) {
        _images.add(await getImageUrl(_userHistory[i]['image']));
      }
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
      body: Container(
      child: ListView.separated(
        itemCount: _userHistory.length,
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
                      child: _images[index] != ''
                            ? FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Image(image: CachedNetworkImageProvider(_images[index]))
                            )
                            : const Center(child:CircularProgressIndicator()),
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
                            _userHistory[index]['title'] != null ? _userHistory[index]['title'] : '...',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 1,),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              _userHistory[index]['explanation'] != null ? _userHistory[index]['explanation'] : '...',
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
              Provider.of<SpotInformationModel>(context, listen: false).updateSpotInfo(_userHistory[index]);
              Provider.of<SpotInformationModel>(context, listen: false).updateImageUrl(_images[index]);
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