import 'dart:async';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stamprally_v2/main.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stamprally_v2/map_page_model.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/spot_information_page.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:stamprally_v2/map_model.dart';
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    // print('hello');
    // Future(() async {
    //   List spot_list = [];
    //   spot_list = await getData('/get/map', {'user_id':userId});
    // });
  }
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 1,
    //     backgroundColor: Colors.white,
    //     centerTitle: true,
    //     title: Image.asset(
    //       'images/appBarImage.png',
    //       height: 38,
    //     ),
    //   ),
    //   body: MapCardPage()

    // );
    return
      isLoggedIn ?
        DefaultTabController(
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
              bottom: TabBar(
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                tabs: <Widget> [
                  Tab(text: "すべて",),
                  Tab(text: "スタンプカード",),
                ],
              ),
            ),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                MapTopPage(),
                MapCardPage(),
              ],
            ),
          ),

        )
      :
      Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(
            'images/appBarImage.png',
            height: 38,
          ),
        ),
        body: MapTopPage()
      );
  }
}

class MapTopPage extends StatefulWidget {
  const MapTopPage({super.key});

  @override
  State<MapTopPage> createState() => _MapTopPageState();
}

class _MapTopPageState extends State<MapTopPage> {
  List<Map<String, dynamic>> genres = [];
  List<Marker> markers = [];
  List images = [];
  List spotsList = [];
  bool isRangeChange = false;
  String searchText = "";
  String tagsString = '';
  final TextEditingController _searchFieldController = new TextEditingController();

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
      Provider.of<MapModel>(context, listen: false).updateZoomLevel(16.0);
      Provider.of<MapModel>(context, listen: false).updateLocationTracking(true);
      List myLocation = Provider.of<MapModel>(context, listen: false).myLocation;
      Provider.of<MapModel>(context, listen: false).mapController.move(LatLng(myLocation[0], myLocation[1]), 16);
      // Provider.of<MapModel>(context, listen: false).updateIsMapDisplayed(true);

    });

    Future(() async {
      LatLngBounds visibleBounds = Provider.of<MapModel>(context, listen: false).mapController.camera.visibleBounds;

      spotsList = await getData(
        '/get/map/range',
        {
          'longitude_min':visibleBounds.southWest.longitude,
          'latitude_min':visibleBounds.southWest.latitude,
          'longitude_max':visibleBounds.northEast.longitude,
          'latitude_max':visibleBounds.northEast.latitude
        },
        false
      );


      List genres_data = await getData('/get/map/suggestion_tags', {}); //スポット　スタンプラリー　はタグから除外
      for (var i = 0; i < genres_data.length; i++) {
        genres.add({"name":genres_data[i]['name'], 'isCheck':false});
      }


      print(spotsList.length);
      for (var i = 0; i < spotsList.length; i++) {
        images.add(await getImageUrl(spotsList[i]['image']));
      }
      for (var i = 0; i < spotsList.length; i++) {
        markers.add(createMarker(LatLng(spotsList[i]['location']['y'], spotsList[i]['location']['x']), spotsList[i], images[i]));
      }
      setState(() {});
    });
  }

  late MapModel _mapModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapModel = Provider.of<MapModel>(context, listen: false);
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
                initialCenter: LatLng(model.myLocation[0], model.myLocation[1]),
                initialZoom: 16,
                maxZoom: 18,
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  if (hasGesture) {
                    model.locationTracking = false;
                    isRangeChange = true;
                    setState(() {

                    });
                  }

                },
                onMapReady: () {
                  model.updateIsMapDisplayed(true);
                }

              ),
              children: [
                // 地図表示のタイルレイヤー
                TileLayer(
                  tileProvider: CancellableNetworkTileProvider(),
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),

                CircleLayer(circles: model.circleMarkers),
                MarkerLayer(markers: markers)
              ],
            ),
            Column(
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
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    controller: _searchFieldController,
                    onSubmitted: (text) async {
                      searchText = text;
                      LatLngBounds visibleBounds = model.mapController.camera.visibleBounds;
                      if (searchText.length > 0) { //範囲指定　useridいらない
                        spotsList = await getData(
                          '/get/map/range/search',
                          {

                            'longitude_min':visibleBounds.southWest.longitude,
                            'latitude_min':visibleBounds.southWest.latitude,
                            'longitude_max':visibleBounds.northEast.longitude,
                            'latitude_max':visibleBounds.northEast.latitude,
                            'text':searchText
                          },
                          false
                        );
                      } else {
                        spotsList = await getData(
                          '/get/map/range',
                          {
                            'longitude_min':visibleBounds.southWest.longitude,
                            'latitude_min':visibleBounds.southWest.latitude,
                            'longitude_max':visibleBounds.northEast.longitude,
                            'latitude_max':visibleBounds.northEast.latitude
                          },
                          false
                        );
                      }
                      print(spotsList.length);
                      markers = [];
                      images = [];
                      for (var i = 0; i < spotsList.length; i++) {
                        images.add(await getImageUrl(spotsList[i]['image']));
                      }
                      for (var i = 0; i < spotsList.length; i++) {
                        markers.add(createMarker(LatLng(spotsList[i]['location']['y'], spotsList[i]['location']['x']), spotsList[i], images[i]));
                      }

                      for (var i = 0; i < genres.length; i++) {
                        genres[i]['isCheck'] = false;
                      }
                      isRangeChange = false;
                      setState(() {

                      });
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10, right:10, bottom:10),
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
                                  color: genres[i]['isCheck'] ? Colors.lightBlue[50] : Colors.white,
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
                                LatLngBounds visibleBounds = model.mapController.camera.visibleBounds;
                                if (tags.length > 0) {
                                  tagsString = tags.join(',');
                                  spotsList = await getData(
                                    '/get/map/range/tag',
                                    {
                                      'longitude_min':visibleBounds.southWest.longitude,
                                      'latitude_min':visibleBounds.southWest.latitude,
                                      'longitude_max':visibleBounds.northEast.longitude,
                                      'latitude_max':visibleBounds.northEast.latitude,
                                      'tag':tagsString
                                    },
                                    false
                                  );
                                } else {
                                  LatLngBounds visibleBounds = model.mapController.camera.visibleBounds;
                                  spotsList = await getData(
                                    '/get/map/range',
                                    {
                                      'longitude_min':visibleBounds.southWest.longitude,
                                      'latitude_min':visibleBounds.southWest.latitude,
                                      'longitude_max':visibleBounds.northEast.longitude,
                                      'latitude_max':visibleBounds.northEast.latitude
                                    },
                                    false
                                  );
                                }
                                markers = [];
                                images = [];
                                for (var i = 0; i < spotsList.length; i++) {
                                  images.add(await getImageUrl(spotsList[i]['image']));
                                }
                                for (var i = 0; i < spotsList.length; i++) {
                                  markers.add(createMarker(LatLng(spotsList[i]['location']['y'], spotsList[i]['location']['x']), spotsList[i], images[i]));
                                }
                                _searchFieldController.clear();
                                searchText = '';
                                isRangeChange = false;
                                setState(() {});
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !model.locationTracking,
              child: Positioned(
                right: 10,
                bottom: 10,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child:IconButton(
                    onPressed: () {
                      model.locationTracking = true;
                      model.mapController.move(LatLng(model.myLocation[0], model.myLocation[1]), model.zoomLevel);
                      setState(() {

                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(
                      ),
                      elevation: 16,
                      backgroundColor: Theme.of(context).primaryColor
                    ),
                    icon: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),

                  ),
                ),
              ),
            ),
            Visibility(
              visible: isRangeChange,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 35,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text('この範囲で検索'),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async  {

                        LatLngBounds visibleBounds = model.mapController.camera.visibleBounds;

                        print(visibleBounds.northEast);
                        print(visibleBounds.southWest);
                        List tempSpotsList = [];
                        if (searchText.isNotEmpty) {
                          tempSpotsList = await getData(
                            '/get/map/range/search',
                            {
                              'longitude_min':visibleBounds.southWest.longitude,
                              'latitude_min':visibleBounds.southWest.latitude,
                              'longitude_max':visibleBounds.northEast.longitude,
                              'latitude_max':visibleBounds.northEast.latitude,
                              'text':searchText
                            },
                            false
                          );
                        } else if (tagsString.isNotEmpty) {
                          tempSpotsList = await getData(
                            '/get/map/range/tag',
                            {
                              'longitude_min':visibleBounds.southWest.longitude,
                              'latitude_min':visibleBounds.southWest.latitude,
                              'longitude_max':visibleBounds.northEast.longitude,
                              'latitude_max':visibleBounds.northEast.latitude,
                              'tag':tagsString
                            },
                            false
                          );
                        } else {
                          tempSpotsList = await getData(
                            '/get/map/range',
                            {
                              'longitude_min':visibleBounds.southWest.longitude,
                              'latitude_min':visibleBounds.southWest.latitude,
                              'longitude_max':visibleBounds.northEast.longitude,
                              'latitude_max':visibleBounds.northEast.latitude
                            },
                            false
                          );
                        }
                        images = [];
                        List spotsListIds = spotsList.map((item) => item['id']).toList();
                        List tempSpotsListIds = tempSpotsList.map((item) => item['id']).toList();
                        print(tempSpotsListIds);
                        for (var i = 0; i < tempSpotsListIds.length; i++) {
                          if(!spotsListIds.contains(tempSpotsListIds[i])) {

                            spotsList.add(tempSpotsList[i]);
                          }
                        }
                        markers = [];
                        print(spotsList.length);
                        for (var i = 0; i < spotsList.length; i++) {
                          images.add(await getImageUrl(spotsList[i]['image']));
                        }
                        for (var i = 0; i < spotsList.length; i++) {
                          markers.add(createMarker(LatLng(spotsList[i]['location']['y'], spotsList[i]['location']['x']), spotsList[i], images[i]));
                        }
                        isRangeChange = false;
                        setState(() {});
                      }
                    ),
                  ),
                ),
              )
            )
          ]
        );
      }
    );
  }
}

class MapCardPage extends StatefulWidget {
  const MapCardPage({super.key});

  @override
  State<MapCardPage> createState() => _MapCardPageState();
}

class _MapCardPageState extends State<MapCardPage> {
  List<Map<String, dynamic>> genres = [];
  List<Marker> markers = [];
  List images = [];
  List spotsList = [];


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
      Provider.of<MapModel>(context, listen: false).updateZoomLevel(16.0);
      Provider.of<MapModel>(context, listen: false).updateLocationTracking(true);
      List myLocation = Provider.of<MapModel>(context, listen: false).myLocation;
      Provider.of<MapModel>(context, listen: false).mapController.move(LatLng(myLocation[0], myLocation[1]), 16);
      // Provider.of<MapModel>(context, listen: false).updateIsMapDisplayed(true);

    });

    Future(() async {

      spotsList = await getData('/get/user/map', {'user_id':userId});
      List genres_data = await getData('/get/map/suggestion_tags', {}); //スポット　スタンプラリー　はタグから除外
      for (var i = 0; i < genres_data.length; i++) {
        genres.add({"name":genres_data[i]['name'], 'isCheck':false});
      }
      print(spotsList.length);
      markers = [];
      images = [];
      for (var i = 0; i < spotsList.length; i++) {
        images.add(await getImageUrl(spotsList[i]['image']));
      }
      for (var i = 0; i < spotsList.length; i++) {
        markers.add(createMarker(LatLng(spotsList[i]['location']['y'], spotsList[i]['location']['x']), spotsList[i], images[i]));
      }
      setState(() {});
    });
  }

  late MapModel _mapModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapModel = Provider.of<MapModel>(context, listen: false);
  }
  @override
  void dispose() {

    super.dispose();
    _mapModel.updateIsMapDisplayed(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapModel>(builder: (context, model, child) {
        return Stack(
          children: [
            FlutterMap(
              mapController: model.mapController,
              options: MapOptions(
                // 地図の中心座標
                initialCenter: LatLng(model.myLocation[0], model.myLocation[1]),
                initialZoom: 16,
                maxZoom: 18,
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  if (hasGesture) {
                    model.locationTracking = false;
                    setState(() {

                    });
                  }

                },
                onMapReady: () {
                  model.updateIsMapDisplayed(true);
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

                CircleLayer(circles: model.circleMarkers),
                MarkerLayer(markers: markers)
              ],
            ),
            Column(
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
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onSubmitted: (text) async {
                      spotsList = [];
                      if (text.length > 0) {
                        spotsList = await getData('/get/user/map/search', {'user_id':userId, 'text':text});
                      } else {
                        spotsList = await getData('/get/user/map', {'user_id':userId});
                      }
                      print(spotsList.length);
                      markers = [];
                      images = [];
                      for (var i = 0; i < spotsList.length; i++) {
                        images.add(await getImageUrl(spotsList[i]['image']));
                      }
                      for (var i = 0; i < spotsList.length; i++) {
                        markers.add(createMarker(LatLng(spotsList[i]['location']['y'], spotsList[i]['location']['x']), spotsList[i], images[i]));
                      }
                      for (var i = 0; i < genres.length; i++) {
                        genres[i]['isCheck'] = false;
                      }
                      setState(() {

                      });
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10, right:10, bottom:10),
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
                                  color: genres[i]['isCheck'] ? Colors.lightBlue[50] : Colors.white,
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
                                spotsList = [];
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
                                  spotsList = await getData('/get/user/map/tag', {'user_id':userId, 'tag':tagsString});
                                } else {
                                  spotsList = await getData('/get/user/map', {'user_id':userId});
                                }
                                markers = [];
                                images = [];
                                for (var i = 0; i < spotsList.length; i++) {
                                  images.add(await getImageUrl(spotsList[i]['image']));
                                }
                                for (var i = 0; i < spotsList.length; i++) {
                                  markers.add(createMarker(LatLng(spotsList[i]['location']['y'], spotsList[i]['location']['x']), spotsList[i], images[i]));
                                }
                                setState(() {});
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !model.locationTracking,
              child: Positioned(
                right: 10,
                bottom: 10,
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
                      model.locationTracking = true;
                      model.mapController.move(LatLng(model.myLocation[0], model.myLocation[1]), model.zoomLevel);

                      setState(() {

                      });
                    },
                  ),
                ),
              ),
            ),
          ]
        );
      }
    );
  }
}

// class MapRallyPage extends StatefulWidget {
//   const MapRallyPage({super.key});

//   @override
//   State<MapRallyPage> createState() => _MapRallyPageState();
// }

// class _MapRallyPageState extends State<MapRallyPage> {
//   static const genres = ["なんかスタンプラリーの名前", "なんかスタンプラリーの名前"];
//   String test_txt = "";


//   @override
//   void initState() {
//     super.initState();

//     Future(() async {
//       var spots_info = await getData('/get/spots/info', {'id':'1'});
//       print(spots_info);
//     });


//     // _getData();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           color: Colors.red,
//           child: Center(child: Text(test_txt, style: TextStyle(fontSize: 20)))
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   contentPadding: EdgeInsets.all(10),
//                   hintText: '検索',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   fillColor: Colors.white,
//                   filled: true
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left:10, right:10, bottom:10),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     for (final genre in genres)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal:5),
//                         child: InkWell(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(999999),
//                               border: Border.all(color: Colors.black54),
//                               color: Colors.white
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical:6, horizontal:15),
//                               child: ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxWidth: 220,
//                                 ),
//                                 child: Text(
//                                   genre,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           onTap: () {},
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }