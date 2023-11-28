import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stamprally_v2/map_page_model.dart';
import 'package:stamprally_v2/rewards_list_model.dart';
import 'package:stamprally_v2/project_information_page_model.dart';
import 'package:stamprally_v2/stamp_page.dart';
import 'package:stamprally_v2/home_page.dart';
import 'package:stamprally_v2/map_page.dart';
import 'package:stamprally_v2/others_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stamprally_v2/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/reward_model.dart';
import 'package:stamprally_v2/unused_reward_model.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:stamprally_v2/map_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

late FirebaseStorage storage;
late FirebaseFirestore _firestore;
var userId = -1;
bool isLoggedIn = false;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Storageのインスタンスを初期化
  storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  // await FirebaseAuth.instance.signOut();
  await Hive.initFlutter();
  var infoBox = await Hive.openBox('info_cache');
  var imageBox = await Hive.openBox('image_cache');
  // Hive.box('info_cache');
  // Hive.box('image_cache');

  await infoBox.deleteFromDisk();
  await imageBox.deleteFromDisk();

  await Hive.openBox('info_cache');
  await Hive.openBox('image_cache');


  if (auth.currentUser == null) {
    isLoggedIn = false;
    userId = -1;
  } else {
    isLoggedIn = true;

    final _uid = auth.currentUser?.uid;
    List userIdData = await getData('/get/user', {'id':_uid});
    userId = userIdData[0]['id'];
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProjectInformationPageModel>(
          create: (_) => ProjectInformationPageModel(),
        ),
        ChangeNotifierProvider<RewardsListModel>(
          create: (_) => RewardsListModel(),
        ),
        ChangeNotifierProvider<RewardModel>(
          create: (_) => RewardModel(),
        ),
        ChangeNotifierProvider<SpotInformationModel>(
          create: (_) => SpotInformationModel(),
        ),
        ChangeNotifierProvider<UnusedRewardModel>(
          create: (_) => UnusedRewardModel(),
        ),
        ChangeNotifierProvider<MapPageModel>(
          create: (_) => MapPageModel(),
        ),
        ChangeNotifierProvider<MapModel>(
          create: (_) => MapModel(),
        ),
      ],
    child: MyApp()
  ));
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stamprally',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List _myLocation = [];
  @override
  void initState(){
    super.initState();
    Future(() async {
      _myLocation = await initLocation();
      Provider.of<MapModel>(context, listen: false).updateMyLocation(_myLocation[0], _myLocation[1]);
      Provider.of<MapModel>(context, listen: false).updateCircleMarkers(_myLocation[0], _myLocation[1]);
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? position) {
          if(position != null) {

            Provider.of<MapModel>(context, listen: false).updateMyLocation(position.latitude, position.longitude);
            _myLocation = Provider.of<MapModel>(context, listen: false).myLocation;
            print(_myLocation);
            Provider.of<MapModel>(context, listen: false).updateCircleMarkers(_myLocation[0], _myLocation[1]);

            if (Provider.of<MapModel>(context, listen: false).locationTracking && Provider.of<MapModel>(context, listen: false).isMapDisplayed) {
              Provider.of<MapModel>(context, listen: false).mapController.move(
                LatLng(position.latitude, position.longitude),
                Provider.of<MapModel>(context, listen: false).zoomLevel
              );

            }
            // if (locationTracking) {
            //   mapController.move(LatLng(position.latitude, position.longitude), zoomLevel);
            // }

            setState(() {});
          }
        }
      );

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isLoggedIn
      ? [
        HomePage(),
        StampPage(),
        MapPage(),
        OthersPage()
      ]
      : [
        HomePage(),
        MapPage(),
        OthersPage()
      ]).elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: isLoggedIn
          ? <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), label: 'スタンプカード'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'マップ'),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'その他'),
          ]
          : <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'マップ'),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'その他'),
          ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blueAccent,
        onTap: (index) {
          _currentIndex = index;
          setState((){});
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}



// Future<List> getRewards(List rewards, FirebaseFirestore firestore, FirebaseStorage storage) async {

//   // 画像のダウンロードURLを取得
//   CollectionReference collection = firestore.collection('Rewards');
//   List getRewardsList = [];
//   for (var i = 0; i < rewards.length; i++) {
//     DocumentSnapshot snapshot = await collection.doc(rewards[i]).get();
//     getRewardsList.add(snapshot.data() as Map<String, dynamic>);
//     getRewardsList[i]["imageUrl"] = await getImageUrl(getRewardsList[i]["images"][0]);
//   }
//   return getRewardsList;
// }

// Future<List> getSpots(List spots, FirebaseFirestore firestore, FirebaseStorage storage) async {

//   // 画像のダウンロードURLを取得
//   CollectionReference collection = firestore.collection('Spots');
//   List getSpotsList = [];
//   for (var i = 0; i < spots.length; i++) {
//     DocumentSnapshot snapshot = await collection.doc(spots[i]).get();
//     getSpotsList.add(snapshot.data() as Map<String, dynamic>);

//     getSpotsList[i]["imageUrl"] = await getImageUrl(getSpotsList[i]["images"][0]);
//   }
//   return getSpotsList;
// }


// Future<List> getReviews(List rewards, FirebaseFirestore firestore) async {

//   // 画像のダウンロードURLを取得
//   CollectionReference collection = firestore.collection('Reviews');
//   List getReviewsList = [];
//   for (var i = 0; i < rewards.length; i++) {
//     getReviewsList.add([]);
//     for (var j = 0; j < rewards[i]["reviews"].length; j++) {
//       DocumentSnapshot snapshot = await collection.doc(rewards[i]["reviews"][j]).get();
//       getReviewsList[i].add(snapshot.data() as Map<String, dynamic>);
//     }
//   }
//   return getReviewsList;
// }


Future<String> getImageUrl(String imagePath) async {
  // 画像のダウンロードURLを取得
  var imageBox= Hive.box('image_cache');
  String? hiveData = imageBox.get(imagePath);
  late String downloadUrl;
  if (hiveData == null) {
    downloadUrl = await storage.ref().child(imagePath).getDownloadURL();
    imageBox.put(imagePath, downloadUrl);
  } else {
    downloadUrl = hiveData;
  }
  return downloadUrl;
}

Uri getPendingUri(path, Map<String, dynamic> request) {
  Uri pendingUri = Uri.http(
    '192.168.1.67:3000',
    path,
    request.map((key, value) => MapEntry(key, value.toString())),
  );
  return pendingUri;
}

Future<List> getData(path, Map<String, dynamic> request) async {
  print(request);
  print(path);

  Uri pendingUri = getPendingUri(path, request);

  late List resList;
  var infoBox = Hive.box('info_cache');
  List? hiveData = infoBox.get(pendingUri.toString());
  if (hiveData == null) {
    var response = await http.get(pendingUri);
    resList = jsonDecode(response.body);
    if(!path.contains('timeline')) infoBox.put(pendingUri.toString(), resList);
  } else {
    resList = hiveData;
  }



  print(resList);
  return resList;
}

Future postData(path, Map<String, dynamic> request) async {
  print(request);

  Uri url = Uri.http(
    "192.168.1.67:3000",
    path,
  );
  print(url);
  // Uri url = Uri.parse("http://192.168.1.67:3000");
  Map<String, String> headers = {'content-type': 'application/json'};
  String body = json.encode(
    request.map((key, value) => MapEntry(key, value.toString()))
  );
  print(body);

  var resp = await http.post(url, headers: headers, body: body);
  if (resp.statusCode != 200) {
    throw 'Failed';
  } else {
    print(resp.statusCode);
  }

}

Future<List> initLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  final latitude = position.latitude;
  final longitude = position.longitude;
  return [latitude, longitude];
}

CircleMarker initCircleMarker(double latitude, double longitude) {
  CircleMarker circleMarler = CircleMarker(
    color: Colors.blue,
    radius: 9,
    borderColor: Colors.white,
    borderStrokeWidth: 3,
    point: LatLng(latitude, longitude),
  );
  return circleMarler;
}

Map<String, dynamic> convertResultToSpotMap(result) {
  Map<String, dynamic> _spotInfo = {
    "id": result["spot_id"],
    "title": result["spot_title"],
    "explanation": result["spot_explanation"],
    "image": result["spot_image"],
    "tag": result["spot_tag"],
    "star": result["spot_star"],
    "location": result["spot_location"],
    "website": result["spot_website"],
    "address": result["spot_address"],
    "openHours": result["spot_openHours"],
    "admissionFee": result["spot_admissionFee"],
    "stamp_rally": result["spot_stamp_rally"],
    "spot_stampcard": result["spot_stampcard"],
    "stampcard_users": result["spot_stampcard_users"],
    "reviews_avg": result["spot_reviews_avg"],
    "is_stamprally": false,
  };
  return _spotInfo;
}
Map<String, dynamic> convertResultToStampRallyMap(result) {
  Map<String, dynamic> _stamprallyInfo = {
    "id": result["stamp_rally_id"],
    "title": result["stamprally_title"],
    "explanation": result["stamprally_explanation"],
    "image": result["stamprally_image"],
    "tag": result["stamprally_tag"],
    "star": result["stamprally_star"],
    "period": result["stamprally_period"],
    "website": result["stamprally_website"],
    "venue": result["stamprally_venue"],
    "reward": result["stamprally_reward"],
    "stamp_rally_stampcard": result["stamp_rally_stampcard"],
    "stampcard_users": result["stamp_rally_stampcard_users"],
    "is_stamprally": true,
  };
  return _stamprallyInfo;
}