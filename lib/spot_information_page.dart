import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stamprally_v2/main.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/map_model.dart';
import 'package:stamprally_v2/post_review.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
class SpotInformationPage extends StatefulWidget {

  // final Map spotInfo;
  // final String imageUrl;
  // final List reviewsList;

  const SpotInformationPage({super.key});

  @override
  State<SpotInformationPage> createState() => _SpotInformationPageState();
}

class _SpotInformationPageState extends State<SpotInformationPage>
     with SingleTickerProviderStateMixin  {

  late Map _spotInfo = {};
  late List _reviewsList = [];
  late int? _tabIndex = 0;
  late List _userCheckedData = [];
  String _imageUrl = '';
  TabController? _tabController;
  bool imgVisibility = true;
  bool _isFocusedMarker = true;
  int reviewsLimit = 10;

  @override
  void initState() {
    super.initState();
    _reviewsList = [];
    _tabController = TabController(vsync: this, length: 3);
    _tabController!.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapModel>(context, listen: false).updateZoomLevel(16.0);
      Provider.of<MapModel>(context, listen: false).updateLocationTracking(false);
    });





    Future(() async {
      _spotInfo = Provider.of<SpotInformationModel>(context, listen: false).spotInfo;
      _reviewsList = Provider.of<SpotInformationModel>(context, listen: false).reviewsList;
      _userCheckedData = await getData('/get/spots/is_checked', {'user_id':userId, 'spot_id':_spotInfo['id']});

      print(_userCheckedData);
      if (_userCheckedData[0]['is_checked'] == 0) {
        Provider.of<SpotInformationModel>(context, listen: false).updateIsChecked(false);
      } else {
        Provider.of<SpotInformationModel>(context, listen: false).updateIsChecked(true);

      }
      List myLocation = Provider.of<MapModel>(context, listen: false).myLocation ;
      // print(Geolocator.distanceBetween(
      //     _spotInfo['location']['y'], _spotInfo['location']['x'],
      //     myLocation[0], myLocation[1]
      //   ));
      if (
        Geolocator.distanceBetween(
          _spotInfo['location']['y'], _spotInfo['location']['x'],
          myLocation[0], myLocation[1]
        ) < 300
      ) {
        Provider.of<SpotInformationModel>(context, listen: false).updateIsNear(true);
      } else {
        Provider.of<SpotInformationModel>(context, listen: false).updateIsNear(false);
      }

      setState(() {});

    });

  }
  void _handleTabChange() {
    if (_tabIndex != _tabController?.index) {
      if (_tabController?.index == 0) {
        imgVisibility = true;
      } else {
        imgVisibility = false;
      }
      if (_tabController?.index == 1) {
        Future(() async {
          print("AA");
          _reviewsList = await getData('/get/spots/reviews', {'spot_id':_spotInfo["id"], 'limit':0});
          Provider.of<SpotInformationModel>(context, listen: false).updateReviewsList(_reviewsList);

        });
      }
      if (_tabController?.index == 2) {
        Provider.of<MapModel>(context, listen: false).updateIsMapDisplayed(true);
      } else {
        Provider.of<MapModel>(context, listen: false).updateIsMapDisplayed(false);
      }
    }
    _tabIndex = _tabController?.index;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabChange);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpotInformationModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(
            'images/appBarImage.png',
            height: 38,
          ),
          actions: [
            Visibility(
              visible: (userId != -1),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5),
                    child: Text(
                      !model.isChecked ? 'Check!' : 'Checked',
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
                  onPressed: (model.isChecked || !model.isNear || (userId == -1)) ? null : () async {
                    await postData('/post/spots/check', {'user_id':userId, 'spot_id':_spotInfo['id']});
                    var infoBox = Hive.box('info_cache');
                    await infoBox.delete(getPendingUri('/get/user/available_rewards_list', {'user_id':userId}).toString());
                    await infoBox.delete(getPendingUri('/get/spots/is_checked', {'user_id':userId, 'spot_id':_spotInfo['id']}).toString());
                    await infoBox.delete(getPendingUri('/get/user/history', {'user_id':userId}).toString());
                    model.updateIsChecked(true);

                    setState(() {
                    });
                  },
                ),
              ),
            ),

          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                  visible: imgVisibility,
                  child: model.imageUrl != ''
                    ? Image(image: CachedNetworkImageProvider(model.imageUrl))
                    : const Center(child:CircularProgressIndicator()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.spotInfo["title"] != null
                    ? model.spotInfo["title"]
                    : "...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


                // タブバー
                Container(
                  width: double.infinity,
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    tabs:  [
                      Tab(child: Container(width: 70, child: Center(child: Text('概要')))),
                      Tab(child: Container(width: 70, child: Center(child: Text('口コミ')))),
                      Tab(child: Container(width: 70, child: Center(child: Text('地図')))),
                    ],
                  ),
                ),
                // タブビュー
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  model.spotInfo["explanation"] != null
                                    ? model.spotInfo["explanation"]
                                    : "...",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.black54),
                                          const SizedBox(width: 8,),
                                          Text(
                                            model.spotInfo["address"] != null
                                              ? model.spotInfo["address"]
                                              : "...",
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Row(
                                        children: [
                                          Icon(Icons.web, color: Colors.black54),
                                          const SizedBox(width: 8,),
                                          Text(
                                            model.spotInfo["website"] != null
                                              ? model.spotInfo["website"]
                                              : "http://example.com",
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Row(
                                        children: [
                                          Icon(Icons.schedule, color: Colors.black54),
                                          const SizedBox(width: 8,),
                                          Text(
                                            model.spotInfo["openHours"] != null
                                              ? model.spotInfo["openHours"]
                                              : "...",
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Row(
                                        children: [
                                          Icon(Icons.currency_yen, color: Colors.black54),
                                          const SizedBox(width: 8,),
                                          Text(
                                            model.spotInfo["admissionFee"] != null
                                              ? model.spotInfo["admissionFee"]
                                              : "...",
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Visibility(
                            visible: (userId != -1),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton.icon(
                                icon: Icon(Icons.rate_review_outlined),
                                label: Text('クチコミを書く'),
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) => PostReview(),
                                    // spotInfo: timeLine[index], imageUrl: images[index], reviewsList: []
                                    //以下を追加
                                    fullscreenDialog: true,
                                  )
                                );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: model.reviewsList.length + 1,
                              itemBuilder: (context, int index) {
                                if (index == model.reviewsList.length) {
                                  print('aaaas');
                                  if (reviewsLimit <= model.reviewsList.length) {
                                    Future(() async {
                                      print("AA");
                                      List getReviewsList = await getData('/get/spots/reviews', {'spot_id':_spotInfo["id"], 'limit':model.reviewsList.length});
                                      _reviewsList = model.reviewsList;
                                      print(_reviewsList);
                                      _reviewsList.addAll(getReviewsList);
                                      model.updateReviewsList(_reviewsList);
                                      setState(() {

                                      });
                                      reviewsLimit += 10;
                                      // model.updateReviewsList();

                                    });
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                                print('ABCDEFH');
                                print(model.reviewsList[index]);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(children: [
                                            for (int i = 0; i < 5; i++)
                                              Icon(
                                                Icons.star,
                                                color: (i < model.reviewsList[index]["star"].round()) ? Colors.orange : Colors.grey,
                                                size: 20,
                                              )
                                          ],),
                                          SizedBox(width: 10,),
                                          Text(model.reviewsList[index]["star"].toString(), style: TextStyle(fontSize: 18),),
                                        ]
                                      ),
                                      SizedBox(height: 2,),
                                      Text(
                                        model.reviewsList[index]["title"],
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      Text(
                                        model.reviewsList[index]["message"]
                                      )
                                    ]
                                  ),
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
                        ],
                      ),
                      Consumer<MapModel>(
                        builder: (context, mapModel, child) {
                          return Stack(
                            children: [
                              FlutterMap(
                                mapController: mapModel.mapController,
                                options: MapOptions(
                                  // 地図の中心座標
                                  initialCenter: LatLng(model.spotInfo['location']['y'],model.spotInfo['location']['x']),
                                  initialZoom: 16,
                                  maxZoom: 18,
                                  onPositionChanged: (MapPosition position, bool hasGesture) {
                                    if (hasGesture) {
                                      mapModel.locationTracking = false;
                                      _isFocusedMarker = false;
                                      setState(() {

                                      });
                                    }

                                  }
                                ),
                                children: [
                                  // 地図表示のタイルレイヤー
                                  TileLayer(
                                    tileProvider: CancellableNetworkTileProvider(),
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.app',
                                    // additionalOptions: {
                                    //   'accessToken': 'tijooIzVTsTVIMoj55aYR3BeBRmhmGyYJpPUrAzcR6VkSiB4Uu0e387O9AM1xtfy',
                                    //   'lang': 'ja'
                                    // },
                                  ),

                                  CircleLayer(circles: mapModel.circleMarkers),
                                  MarkerLayer(markers: [
                                     Marker(
                                      point: LatLng(model.spotInfo['location']['y'],model.spotInfo['location']['x']),
                                      width: 120,
                                      height: 120,
                                      child: GestureDetector(
                                        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                                      ),
                                      rotate: true,
                                    )
                                  ])
                                ],
                              ),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: !mapModel.locationTracking,
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.my_location,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(
                                            ),
                                            elevation: 16,
                                            backgroundColor: Theme.of(context).primaryColor
                                          ),
                                          onPressed: () {
                                            mapModel.locationTracking = true;
                                            _isFocusedMarker = false;
                                            mapModel.mapController.move(LatLng(mapModel.myLocation[0], mapModel.myLocation[1]), mapModel.zoomLevel);
                                            setState(() {

                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !_isFocusedMarker && !mapModel.locationTracking,
                                      child: SizedBox(height:10)
                                    ),
                                    Visibility(
                                      visible: !_isFocusedMarker,
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(
                                            ),
                                            elevation: 16,
                                            backgroundColor: Theme.of(context).primaryColor
                                          ),
                                          onPressed: () {
                                            _isFocusedMarker = true;
                                            mapModel.locationTracking = false;
                                            mapModel.mapController.move(LatLng(model.spotInfo['location']['y'],model.spotInfo['location']['x']), mapModel.zoomLevel);
                                            setState(() {

                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}