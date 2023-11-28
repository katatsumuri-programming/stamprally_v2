import 'package:flutter/material.dart';
import 'package:stamprally_v2/main.dart';
import 'package:stamprally_v2/rewards_list_model.dart';
import 'package:stamprally_v2/spot_information_page.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:stamprally_v2/my_rewards_page.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/project_information_page_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stamprally_v2/map_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
class ProjectInformationPage extends StatefulWidget {
  // final Map projectInfo;
  // final String imageUrl;
  const ProjectInformationPage({super.key});

  @override
  State<ProjectInformationPage> createState() => _ProjectInformationPageState();
}

class _ProjectInformationPageState extends State<ProjectInformationPage> {

  late Map _projectInfo = {};
  late List _rewardsList = [];
  late List _spotsList = [];
  late String _imageUrl = "";
  Map<String, dynamic> stamprally_info = {};


  @override
  void initState() {

    super.initState();
    // _projectInfo = widget.projectInfo;
    // _imageUrl = widget.imageUrl;

    _projectInfo = Provider.of<ProjectInformationPageModel>(context, listen: false).stamprallyInfo;
    Future(() async {
      print("AA");
      _rewardsList = await getData('/get/rewards', {'id':_projectInfo["id"]}) ;
      _spotsList = await getData('/get/spots/info', {'id':_projectInfo["id"]}) ;
      Provider.of<RewardsListModel>(context, listen: false).updateRewardList(_rewardsList);
      Provider.of<ProjectInformationPageModel>(context, listen: false).updateSpotList(_spotsList);
      List spotImages = [];
      List latAvg = [];
      List lngAvg = [];
      for (var i = 0; i < _spotsList.length; i++) {
        spotImages.add(await getImageUrl(_spotsList[i]['image']));
        latAvg.add(_spotsList[i]['location']['y']);
        lngAvg.add(_spotsList[i]['location']['x']);
      }
      Provider.of<ProjectInformationPageModel>(context, listen: false).updateImageUrlList(spotImages);

      List rewardImages = [];
      for (var i = 0; i < _rewardsList.length; i++) {
        rewardImages.add(await getImageUrl(_rewardsList[i]['image']));
      }
      Provider.of<RewardsListModel>(context, listen: false).updateImageUrlList(rewardImages);


      Provider.of<ProjectInformationPageModel>(context, listen: false).updateBounds(
        LatLngBounds.fromPoints(
          [
            LatLng(latAvg.reduce((curr, next) => curr > next ? curr : next), lngAvg.reduce((curr, next) => curr > next ? curr : next)),
            LatLng(latAvg.reduce((curr, next) => curr < next ? curr : next), lngAvg.reduce((curr, next) => curr < next ? curr : next)),
          ],
        )
      );

      setState(() {});
    });



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
        body: TabBarView(
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
  void initState() {

    super.initState();

  }
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
                RewardsList(),

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
    return Consumer<ProjectInformationPageModel>(builder: (context, model, child) {

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
                          child: model.imageUrlList[index] != ''
                            ? FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Image(image: CachedNetworkImageProvider(model.imageUrlList[index]))
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
                                model.spotsList[index]["title"] != null
                                  ? model.spotsList[index]["title"]
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
                  Provider.of<SpotInformationModel>(context, listen: false).updateSpotInfo(model.spotsList[index]);
                  Provider.of<SpotInformationModel>(context, listen: false).updateImageUrl(model.imageUrlList[index]);
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
  List<Marker> markers = [];
  LatLngBounds bounds = LatLngBounds(LatLng(0,0), LatLng(0,0));
  bool _isFocusedMarker = true;

  Marker createMarker(LatLng position, Map spotInfo, String imageUrl) {
    Marker marker = Marker(
      point: position,
      width: 120,
      height: 120,
      child: GestureDetector(
        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
        onTap: () {
          Provider.of<SpotInformationModel>(context, listen: false).updateSpotInfo(spotInfo);
          Provider.of<SpotInformationModel>(context, listen: false).updateImageUrl(imageUrl);
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => SpotInformationPage(),
              //以下を追加
              fullscreenDialog: true,
            )
          );
        },
      ),
      rotate: true,
    );
    return marker;
  }

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapModel>(context, listen: false).updateIsMapDisplayed(true);
      Provider.of<MapModel>(context, listen: false).updateZoomLevel(16.0);
      Provider.of<MapModel>(context, listen: false).updateLocationTracking(false);

      List spotInfo = Provider.of<ProjectInformationPageModel>(context, listen: false).spotsList;
      List spotImages = Provider.of<ProjectInformationPageModel>(context, listen: false).imageUrlList;

      for (var i = 0; i < spotInfo.length; i++) {
        markers.add(
          createMarker(LatLng(spotInfo[i]['location']['y'], spotInfo[i]['location']['x']), spotInfo[i], spotImages[i])
        );
      }


      setState(() {

      });
    });


  }
  late MapModel _mapModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapModel = Provider.of<MapModel>(context, listen: false);
    // print('fa');
  }
  @override
  void dispose() {

    super.dispose();
    _mapModel.updateIsMapDisplayed(false);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<MapModel>(
      builder: (context, model, child) {
        return Stack(
          children: [
            FlutterMap(
              mapController: model.mapController,
              options: MapOptions(
                // 地図の中心座標
                initialZoom: 16,
                maxZoom: 18,

                initialCameraFit: CameraFit.bounds(
                  bounds: Provider.of<ProjectInformationPageModel>(context, listen: false).bounds,
                ),
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  if (hasGesture) {
                    model.locationTracking = false;
                    _isFocusedMarker = false;
                    setState(() {


                    });
                  }

                }
              ),
              children: [
                // 地図表示のタイルレイヤー
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  // additionalOptions: {
                  //   'accessToken': 'tijooIzVTsTVIMoj55aYR3BeBRmhmGyYJpPUrAzcR6VkSiB4Uu0e387O9AM1xtfy',
                  //   'lang': 'ja'
                  // },
                ),

                CircleLayer(circles: model.circleMarkers),
                MarkerLayer(markers: markers)
              ],
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Column(
                children: [
                  Visibility(
                    visible: !model.locationTracking,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: ElevatedButton(
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(
                          ),
                          elevation: 16,
                        ),
                        onPressed: () {
                          model.locationTracking = true;
                          _isFocusedMarker = false;
                          model.mapController.move(LatLng(model.myLocation[0], model.myLocation[1]), model.zoomLevel);
                          setState(() {

                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isFocusedMarker && !model.locationTracking,
                    child: SizedBox(height:10)
                  ),
                  Visibility(
                    visible: !_isFocusedMarker,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: ElevatedButton(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(
                          ),
                          elevation: 16,
                        ),
                        onPressed: () {
                          _isFocusedMarker = true;
                          model.locationTracking = false;
                          model.mapController.fitCamera(
                            CameraFit.bounds(
                              bounds: bounds,
                            )
                          );
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
    );
  }
}