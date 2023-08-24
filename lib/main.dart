import 'package:flutter/material.dart';
import 'package:stamprally_v2/rewards_model.dart';
import 'package:stamprally_v2/project_information_page_mdoel.dart';
import 'package:stamprally_v2/stamp_page.dart';
import 'package:stamprally_v2/home_page.dart';
import 'package:stamprally_v2/map_page.dart';
import 'package:stamprally_v2/history_page.dart';
import 'package:stamprally_v2/others_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stamprally_v2/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stamprally_v2/rewards_model.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



late FirebaseStorage _storage;
late FirebaseFirestore _firestore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProjectInformationPageModel>(
          create: (_) => ProjectInformationPageModel(),
        ),
        ChangeNotifierProvider<RewardsModel>(
          create: (_) => RewardsModel(),
        ),
        ChangeNotifierProvider<SpotInformationModel>(
          create: (_) => SpotInformationModel(),
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
  final _pageWidgets = [
    HomePage(),
    StampPage(),
    MapPage(),
    OthersPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), label: 'スタンプカード'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'マップ'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'その他'),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
  void _onItemTapped(int index) => setState(() => _currentIndex = index );
}

Future<String> getImageUrl(String imagePath, FirebaseStorage storage) async {
  // 画像のダウンロードURLを取得
  String downloadUrl = await storage.ref().child(imagePath).getDownloadURL();
  return downloadUrl;
}

Future<List> getRewards(List rewards, FirebaseFirestore firestore, FirebaseStorage storage) async {

  // 画像のダウンロードURLを取得
  CollectionReference collection = firestore.collection('Rewards');
  List getRewardsList = [];
  for (var i = 0; i < rewards.length; i++) {
    DocumentSnapshot snapshot = await collection.doc(rewards[i]).get();
    getRewardsList.add(snapshot.data() as Map<String, dynamic>);

    getRewardsList[i]["imageUrl"] = await getImageUrl(getRewardsList[i]["images"][0], storage);
  }
  return getRewardsList;



}

Future<List> getSpots(List spots, FirebaseFirestore firestore, FirebaseStorage storage) async {

  // 画像のダウンロードURLを取得
  CollectionReference collection = firestore.collection('Spots');
  List getSpotsList = [];
  for (var i = 0; i < spots.length; i++) {
    DocumentSnapshot snapshot = await collection.doc(spots[i]).get();
    getSpotsList.add(snapshot.data() as Map<String, dynamic>);

    getSpotsList[i]["imageUrl"] = await getImageUrl(getSpotsList[i]["images"][0], storage);
  }
  return getSpotsList;



}


Future<List> getReviews(List rewards, FirebaseFirestore firestore) async {

  // 画像のダウンロードURLを取得
  CollectionReference collection = firestore.collection('Reviews');
  List getReviewsList = [];
  for (var i = 0; i < rewards.length; i++) {
    getReviewsList.add([]);
    for (var j = 0; j < rewards[i]["reviews"].length; j++) {
      DocumentSnapshot snapshot = await collection.doc(rewards[i]["reviews"][j]).get();
      getReviewsList[i].add(snapshot.data() as Map<String, dynamic>);
    }

  }

  return getReviewsList;



}


Future<List> getData(getDataType,id) async {
  var response = await http.get(
    Uri.parse(
      'http://192.168.1.73:3000',
    ).replace(queryParameters: {'type':getDataType, 'id':id}),
  );
  print(jsonDecode(response.body));
  return jsonDecode(response.body);
}