import "package:flutter/material.dart";
import 'package:stamprally_v2/project_information_page.dart';
import 'package:stamprally_v2/spot_information_page.dart';
import 'package:stamprally_v2/main.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/project_information_page_model.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
class StampPage extends StatefulWidget {
  const StampPage({super.key});

  @override
  State<StampPage> createState() => _StampPageState();
}

class _StampPageState extends State<StampPage> {
  var stamp_total = 5;
  List<Map<String, dynamic>> genres = [];
  List stampcardList = [];
  List _images = [];
  Map<String, dynamic> _spotInfo = {};
  Map<String, dynamic> _stamprallyInfo = {};
  bool _is_found_result = true;
  final TextEditingController _searchFieldController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    Future(() async {

      stampcardList = await getData('/get/user/stampcard', {'user_id':userId});
      for (var i = 0; i < stampcardList.length; i++) {
        if (stampcardList[i]['spot_image'] != null) {
          _images.add(await getImageUrl(stampcardList[i]['spot_image']));
        } else if (stampcardList[i]['stamprally_image'] != null) {
          _images.add(await getImageUrl(stampcardList[i]['stamprally_image']));
        }
      }
      List genres_data = await getData('/get/suggestion_tags', {});
      for (var i = 0; i < genres_data.length; i++) {
        genres.add({"name":genres_data[i]['name'], 'isCheck':false});
      }
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(10),
                  hintText: '検索',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                controller: _searchFieldController,
                onSubmitted: (text) async {
                  if (text.isNotEmpty) {
                    stampcardList = await getData('/get/user/stampcard/search', {'user_id':userId, 'text':text});
                  } else {
                    stampcardList = await getData('/get/user/stampcard', {'user_id':userId});
                  }
                  for (var i = 0; i < stampcardList.length; i++) {
                    if (stampcardList[i]['spot_image'] != null) {
                      _images.add(await getImageUrl(stampcardList[i]['spot_image']));
                    } else if (stampcardList[i]['stamprally_image'] != null) {
                      _images.add(await getImageUrl(stampcardList[i]['stamprally_image']));
                    }
                  }
                  _is_found_result = stampcardList.isNotEmpty;
                  for (var i = 0; i < genres.length; i++) {
                    genres[i]['isCheck'] = false;
                  }
                  setState(() {

                  });
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < genres.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:5),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999999),
                              border: Border.all(color: genres[i]['isCheck'] ? Colors.blue : Colors.black54),
                              color: genres[i]['isCheck'] ? Colors.lightBlue.withOpacity(0.1) : Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:6, horizontal:15),
                              child: Text(
                                genres[i]['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: genres[i]['isCheck'] ? Colors.blue : Colors.black87,
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

                            if (tags.length > 0) {
                              String tagsString = tags.join(',');
                              stampcardList = await getData('/get/user/stampcard/tag', {'user_id':userId, 'tag':tagsString});
                            } else {
                              stampcardList = await getData('/get/user/stampcard', {'user_id':userId});
                            }
                            for (var i = 0; i < stampcardList.length; i++) {
                              if (stampcardList[i]['spot_image'] != null) {
                                _images.add(await getImageUrl(stampcardList[i]['spot_image']));
                              } else if (stampcardList[i]['stamprally_image'] != null) {
                                _images.add(await getImageUrl(stampcardList[i]['stamprally_image']));
                              }
                            }
                            _is_found_result = stampcardList.isNotEmpty;
                            _searchFieldController.clear();
                            setState(() {

                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !_is_found_result,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text("見つかりませんでした"),
              ),
            ),
            Flexible(
              child: ListView.separated(
                itemCount: stampcardList.length,
                itemBuilder: (context, int index) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0, vertical:10.0),
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
                            height: 90,
                            width: 90,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left:15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stampcardList[index]["stamprally_title"] != null
                                      ? stampcardList[index]["stamprally_title"]
                                      : stampcardList[index]["spot_title"] != null
                                      ? stampcardList[index]["spot_title"]
                                      : "",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Visibility(
                                    visible: (stampcardList[index]["stamprally_venue"] != null && stampcardList[index]["stamprally_period"] != null),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(

                                          stampcardList[index]["stamprally_venue"] != null
                                          ? '場所:${stampcardList[index]["stamprally_venue"]}'
                                          : "",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          stampcardList[index]["stamprally_period"] != null
                                          ? '期間:${stampcardList[index]["stamprally_period"]}'
                                          : "",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: true,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 1,),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            stampcardList[index]["stamprally_explanation"] != null
                                              ? stampcardList[index]["stamprally_explanation"]
                                              : stampcardList[index]["spot_explanation"] != null
                                              ? stampcardList[index]["spot_explanation"]
                                              : "",
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
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {

                      print(stampcardList[index]["stamprally_venue"]);
                      if (stampcardList[index]["spot_id"] != null) {
                        _spotInfo = {
                          "id": stampcardList[index]["spot_id"],
                          "title": stampcardList[index]["spot_title"],
                          "explanation": stampcardList[index]["spot_explanation"],
                          "image": stampcardList[index]["spot_image"],
                          "tag": stampcardList[index]["spot_tag"],
                          "bookmark": stampcardList[index]["spot_bookmark"],
                          "star": stampcardList[index]["spot_star"],
                          "location": stampcardList[index]["spot_location"],
                          "website": stampcardList[index]["spot_website"],
                          "address": stampcardList[index]["spot_address"],
                          "openHours": stampcardList[index]["spot_openHours"],
                          "admissionFee": stampcardList[index]["spot_admissionFee"],
                          "stamp_rally": stampcardList[index]["spot_stamp_rally"]
                        };
                        Provider.of<SpotInformationModel>(context, listen: false).updateImageUrl(await getImageUrl(stampcardList[index]["spot_image"]));
                        Provider.of<SpotInformationModel>(context, listen: false).updateSpotInfo(_spotInfo);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SpotInformationPage()),
                        );
                      } else if (stampcardList[index]["stamp_rally_id"] != null) {
                        _stamprallyInfo = {
                          "id": stampcardList[index]["stamp_rally_id"],
                          "title": stampcardList[index]["stamprally_title"],
                          "explanation": stampcardList[index]["stamprally_explanation"],
                          "image": stampcardList[index]["stamprally_image"],
                          "tag": stampcardList[index]["stamprally_tag"],
                          "bookmark": stampcardList[index]["stamprally_bookmark"],
                          "star": stampcardList[index]["stamprally_star"],
                          "period": stampcardList[index]["stamprally_period"],
                          "website": stampcardList[index]["stamprally_website"],
                          "venue": stampcardList[index]["stamprally_venue"],
                          "reward": stampcardList[index]["stamprally_reward"]
                        };
                        print(_stamprallyInfo);
                        Provider.of<ProjectInformationPageModel>(context, listen: false).updateImageUrl(await getImageUrl(stampcardList[index]["stamprally_image"]));
                        Provider.of<ProjectInformationPageModel>(context, listen: false).updateStamprallyInfo(_stamprallyInfo);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProjectInformationPage()),
                        );
                      }
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
            ),
          ],
        )
      ),
    );
  }
}
