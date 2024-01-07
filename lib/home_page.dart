import 'package:flutter/material.dart';
import 'package:stamprally_v2/map_model.dart';
import 'package:stamprally_v2/project_information_page.dart';
import 'package:stamprally_v2/project_information_page_model.dart';
import 'package:stamprally_v2/post_page.dart';
import 'package:stamprally_v2/spot_information_page.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:stamprally_v2/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int stampNum = 0;
  List spots_info = [];
  List<String> images = [];
  List stampRallies = [];
  List<Map<String,dynamic>> timeLine = [];
  List<Map<String, dynamic>> genres = [];
  bool _is_found_result = true;
  bool _isMount = true;
  int timeLineLimit = 10;
  String searchText = "";
  String tagsString = '';
  List myLocation = [0,0];
  final TextEditingController _searchFieldController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _isMount = true;

    Future(() async {
      timeLineLimit = 10;
      print('aaaa');
      myLocation = Provider.of<MapModel>(context, listen: false).myLocation;
      print(myLocation);
      spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'user_id':userId});
      print('cccc');
      if (userId != null) {
        List stamp_num_data = await getData('/get/user/stampnum', {'user_id':userId});
        stampNum = stamp_num_data[0]['stamp_num'];
      }

      List genres_data = await getData('/get/suggestion_tags', {});
      for (var i = 0; i < genres_data.length; i++) {
        genres.add({"name":genres_data[i]['name'], 'isCheck':false});
      }

      // print(timeLine);
      for (var i = 0; i < spots_info.length; i++) {
        if (spots_info[i]['has_stamprally_tags'] == 'TRUE'){
          if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
            stampRallies.add(spots_info[i]['stamprally_id']);
            timeLine.add(convertResultToStampRallyMap(spots_info[i]));

          }
        }
        if (spots_info[i]['has_spot_tags'] == 'TRUE'){
          timeLine.add(convertResultToSpotMap(spots_info[i]));
        }
      }






      // for (var i = 0; i < timeLine.length; i++) {
      //   images.add(await getImageUrl(timeLine[i]['image']));
      // }

      var futures = <Future<String>>[];
      for (var i = 0; i < timeLine.length; i++) {
        futures.add(getImageUrl(timeLine[i]['image']));
      }
      images = await Future.wait(futures);

      print(timeLine);
      print(images);

      if(_isMount) setState(() {});
      // print(await getData('/get/spots/reviews', {'id':'1', 'limit_start':'0', 'limit_end':'10'}));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _isMount = false;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: isLoggedIn,
            child: Padding(
              padding: const EdgeInsets.only(left:8, right:8, top:8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey, //色
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text(
                      "合計スタンプ",
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    const Spacer(),
                    Text(
                      stampNum.toString(),
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.all(10),
                hintText: '検索',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )

              ),
              controller: _searchFieldController,
              onSubmitted: (text) async {
                searchText = text;
                print(text);
                timeLine = [];
                stampRallies = [];
                myLocation = Provider.of<MapModel>(context, listen: false).myLocation;
                if (text.length > 0) {
                  spots_info = await getData('/get/timeline/search', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'text':text, 'user_id':userId});

                  for (var i = 0; i < spots_info.length; i++) {
                    if (spots_info[i]['has_stamprally_keyword'] == 'TRUE'){
                      if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
                        stampRallies.add(spots_info[i]['stamprally_id']);
                        timeLine.add(convertResultToStampRallyMap(spots_info[i]));
                      }
                    }
                    if (spots_info[i]['has_spot_keyword'] == 'TRUE'){
                      timeLine.add(convertResultToSpotMap(spots_info[i]));
                    }
                  }
                } else {
                  print('aaaaaaaaa');
                  spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'user_id': userId});

                  for (var i = 0; i < spots_info.length; i++) {
                    if (spots_info[i]['has_stamprally_tags'] == 'TRUE'){
                      if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
                        stampRallies.add(spots_info[i]['stamprally_id']);
                        timeLine.add(convertResultToStampRallyMap(spots_info[i]));

                      }
                    }
                    if (spots_info[i]['has_spot_tags'] == 'TRUE'){
                      timeLine.add(convertResultToSpotMap(spots_info[i]));
                    }
                  }
                }
                // genres = [{"name":"スタンプラリー", "isCheck":false}, {"name":"スポット", "isCheck":false}, {"name":"グルメ", "isCheck":false}, {"name":"フォト", "isCheck":false}];
                for (var i = 0; i < genres.length; i++) {
                  genres[i]['isCheck'] = false;
                }
                tagsString = '';
                images = [];
                for (var i = 0; i < timeLine.length; i++) {
                  images.add(await getImageUrl(timeLine[i]['image']));
                }
                if (text.length > 0) {
                  _is_found_result = timeLine.isNotEmpty;
                } else {
                  _is_found_result = true;
                }
                timeLineLimit = 10;
                if(_isMount) setState(() {});
              }
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < genres.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: genres[i]['isCheck'] ? Theme.of(context).primaryColor : Colors.black54),
                            color: genres[i]['isCheck'] ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:6, horizontal:15),
                            child: Text(
                              genres[i]['name'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: genres[i]['isCheck'] ? Theme.of(context).primaryColor : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (!genres[i]["isCheck"]) {
                            genres[i]["isCheck"] = true;

                          } else {
                            genres[i]["isCheck"] = false;
                          }
                          List tags = [];
                          genres.forEach((value) {
                            if (value['isCheck']) {
                              tags.add(value['name']);
                            }
                          });
                          myLocation = Provider.of<MapModel>(context, listen: false).myLocation;
                          if (tags.length > 0) {
                            tagsString = tags.join(',');
                            spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'tag':tagsString, 'user_id': userId});
                            timeLineLimit = 10;
                          } else {
                            spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'user_id': userId});
                            timeLineLimit = 10;
                            tagsString = '';
                          }
                          timeLine = [];
                          images = [];
                          stampRallies = [];
                          for (var i = 0; i < spots_info.length; i++) {
                            if (spots_info[i]['has_stamprally_tags'] == 'TRUE'){
                              if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
                                stampRallies.add(spots_info[i]['stamprally_id']);
                                timeLine.add(convertResultToStampRallyMap(spots_info[i]));
                              }
                            }
                            if (spots_info[i]['has_spot_tags'] == 'TRUE'){
                              timeLine.add(convertResultToSpotMap(spots_info[i]));
                            }
                          }
                          for (var i = 0; i < timeLine.length; i++) {
                            images.add(await getImageUrl(timeLine[i]['image']));
                          }
                          _searchFieldController.clear();
                          searchText = '';
                          timeLineLimit = 10;

                          print(spots_info);

                          if(_isMount) setState(() {});

                        }
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Visibility(
            visible: !_is_found_result,
            child: const Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("見つかりませんでした"),
            ),
          ),
          Flexible(
            child: RefreshIndicator(
              color: Theme.of(context).primaryColor,
              onRefresh: () async {
                timeLine = [];
                stampRallies = [];
                myLocation = Provider.of<MapModel>(context, listen: false).myLocation;
                if (searchText != '') {
                  spots_info = await getData('/get/timeline/search', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'text':searchText, 'user_id':userId});

                  for (var i = 0; i < spots_info.length; i++) {
                    if (spots_info[i]['has_stamprally_keyword'] == 'TRUE'){
                      if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
                        stampRallies.add(spots_info[i]['stamprally_id']);
                        timeLine.add(convertResultToStampRallyMap(spots_info[i]));
                      }
                    }
                    if (spots_info[i]['has_spot_keyword'] == 'TRUE'){
                      timeLine.add(convertResultToSpotMap(spots_info[i]));
                    }
                  }
                } else {
                  if (tagsString.length > 0) {
                    spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'tag':tagsString, 'user_id': userId});
                  } else {
                    spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':0, 'user_id': userId});
                  }

                  for (var i = 0; i < spots_info.length; i++) {
                    if (spots_info[i]['has_stamprally_tags'] == 'TRUE'){
                      if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
                        stampRallies.add(spots_info[i]['stamprally_id']);
                        timeLine.add(convertResultToStampRallyMap(spots_info[i]));
                      }
                    }
                    if (spots_info[i]['has_spot_tags'] == 'TRUE'){
                      timeLine.add(convertResultToSpotMap(spots_info[i]));
                    }
                  }
                }


                var futures = <Future<String>>[];
                for (var i = 0; i < timeLine.length; i++) {
                  futures.add(getImageUrl(timeLine[i]['image']));
                }
                images = await Future.wait(futures);

                timeLineLimit = 10;
                setState(() { });

              },
              child: ListView.separated(
              itemCount: timeLine.length + 1,
              itemBuilder: (context, index) {
                if (index == timeLine.length) {
                  if (timeLineLimit <= timeLine.length) {
 print('abc');
                    Future(() async {
                      if (searchText != '') {
                        spots_info = await getData('/get/timeline/search', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':timeLine.length, 'text':searchText, 'user_id':userId});

                        for (var i = 0; i < spots_info.length; i++) {
                          if (spots_info[i]['has_stamprally_keyword'] == 'TRUE'){
                            if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
                              stampRallies.add(spots_info[i]['stamprally_id']);
                              timeLine.add(convertResultToStampRallyMap(spots_info[i]));
                            }
                          }
                          if (spots_info[i]['has_spot_keyword'] == 'TRUE'){
                            timeLine.add(convertResultToSpotMap(spots_info[i]));
                          }
                        }
                      } else  {
                        if (tagsString.length > 0) {
                          spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':timeLine.length, 'tag':tagsString, 'user_id': userId});
                        } else {
                          spots_info = await getData('/get/timeline', {'lon':myLocation[1], 'lat':myLocation[0], 'limit':timeLine.length, 'user_id': userId});
                        }
                        for (var i = 0; i < spots_info.length; i++) {
                          if (spots_info[i]['has_stamprally_tags'] == 'TRUE'){
                            if (!(stampRallies.contains(spots_info[i]['stamprally_id']))) {
                              stampRallies.add(spots_info[i]['stamprally_id']);
                              timeLine.add(convertResultToStampRallyMap(spots_info[i]));
                            }
                          }
                          if (spots_info[i]['has_spot_tags'] == 'TRUE'){
                            timeLine.add(convertResultToSpotMap(spots_info[i]));
                          }
                        }
                      }


                      var futures = <Future<String>>[];
                      for (var i = 0; i < timeLine.length; i++) {
                        futures.add(getImageUrl(timeLine[i]['image']));
                      }
                      images = await Future.wait(futures);

                      timeLineLimit += 10;
                      setState(() { });
                    });
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Container();
                  }

                }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                              (images.length > 0)
                              ? Image(image: CachedNetworkImageProvider(images[index])) //Image.network(images[index])//
                              : Center(child:CircularProgressIndicator())

                          ),
                          const SizedBox(height: 6,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  timeLine[index]["title"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                Visibility(
                                  visible: isLoggedIn,
                                  child: InkWell(
                                    child: Icon(
                                      (timeLine[index]["is_stamprally"] && (timeLine[index]["stamp_rally_stampcard"] > 0)) ? Icons.star
                                      : (!timeLine[index]["is_stamprally"] && (timeLine[index]["spot_stampcard"] > 0)) ? Icons.star : Icons.star_outline,
                                      color: (timeLine[index]["is_stamprally"] && (timeLine[index]["stamp_rally_stampcard"] > 0)) ? Colors.orange
                                      : (!timeLine[index]["is_stamprally"] && (timeLine[index]["spot_stampcard"] > 0)) ? Colors.orange : Colors.grey,
                                      size: 25,
                                    ),
                                    onTap: () async {
                                      if (timeLine[index]["is_stamprally"]) {
                                        if (timeLine[index]["stamp_rally_stampcard"] > 0) {
                                          await postData('/post/stampcard/remove', {'user_id':userId, 'stamprally_id':timeLine[index]["id"]});
                                          timeLine[index]["stamp_rally_stampcard"] = 0;
                                        } else {
                                          await postData('/post/stampcard/add', {'user_id':userId, 'stamprally_id':timeLine[index]["id"]});
                                          timeLine[index]["stamp_rally_stampcard"] = 1;
                                        }
                                      } else if (!timeLine[index]["is_stamprally"]) {
                                        if (timeLine[index]["spot_stampcard"] > 0) {
                                          await postData('/post/stampcard/remove', {'user_id':userId, 'spot_id':timeLine[index]["id"]});
                                          timeLine[index]["spot_stampcard"] = 0;
                                        } else {
                                          await postData('/post/stampcard/add', {'user_id':userId, 'spot_id':timeLine[index]["id"]});
                                          timeLine[index]["spot_stampcard"] = 1;
                                        }
                                      }
                                      var infoBox = Hive.box('info_cache');
                                      await infoBox.delete(getPendingUri('/get/user/stampcard', {'user_id':userId}).toString());

                                      if(_isMount) setState(() {});
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              timeLine[index]["explanation"],
                              style: TextStyle(
                                fontSize: 13
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: !timeLine[index]["is_stamprally"],
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(children: [
                                        for (int i = 0; i < 5; i++)
                                          Icon(
                                            Icons.star,
                                            color: (i < (timeLine[index]["reviews_avg"] != null ? timeLine[index]["reviews_avg"].floor() : 0)) ? Colors.orange : Colors.grey,
                                          )
                                      ],),
                                      Text(timeLine[index]["reviews_avg"] != null ? timeLine[index]["reviews_avg"].toString() : '', style: TextStyle(fontSize: 20),),
                                      // const SizedBox(width: 15,),sssss
                                      // Icon(Icons.chat, color: Colors.grey, size: 17,),
                                      // const SizedBox(width: 5,),
                                      // Text("5000人", style: TextStyle(fontSize:14)),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 15,),
                                Icon(Icons.bookmark, color: Colors.grey, size: 17,),
                                const SizedBox(width: 5,),
                                Text(timeLine[index]["stampcard_users"].toString(), style: TextStyle(fontSize:14))
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < timeLine[index]["tag"].length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:2, horizontal:5),
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999999),
                                      border: Border.all(color: Theme.of(context).primaryColor),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical:5, horizontal:12),
                                    child: Text(
                                      timeLine[index]["tag"][i],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  onTap: () {

                                  },
                                ),
                              )
                            ],
                          )
                        ]
                      ),
                      onTap: () {
                        if (timeLine[index]["is_stamprally"])  {
                          Provider.of<ProjectInformationPageModel>(context, listen: false).updateStamprallyInfo(timeLine[index]);
                          Provider.of<ProjectInformationPageModel>(context, listen: false).updateImageUrl(images[index]);
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => ProjectInformationPage(),
                              // spotInfo: timeLine[index], imageUrl: images[index], reviewsList: []
                              //以下を追加
                              fullscreenDialog: true,
                            )
                          );
                        } else {
                          Provider.of<SpotInformationModel>(context, listen: false).updateSpotInfo(timeLine[index]);
                          Provider.of<SpotInformationModel>(context, listen: false).updateImageUrl(images[index]);
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => SpotInformationPage(),
                              //以下を追加
                              fullscreenDialog: true,
                            )
                          );
                        }
                      }
                    )
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Divider(
                      height: 1,

                    ),
                  );
                },
              ),
            ),
          )

        ],
      ),

    );
  }
}