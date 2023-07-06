import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stamprally_v2/main.dart';
import 'package:stamprally_v2/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpotInformationPage extends StatefulWidget {

  final Map<String, dynamic> spotInfo;
  final List reviewsList;

  const SpotInformationPage({Key? key, required this.spotInfo, required this.reviewsList}) : super(key: key);

  @override
  State<SpotInformationPage> createState() => _SpotInformationPageState();
}

class _SpotInformationPageState extends State<SpotInformationPage>
     with SingleTickerProviderStateMixin  {

  late String spotId;
  late FirebaseStorage _storage;
  late FirebaseFirestore _firestore;
  late Map<String, dynamic> _spotInfo = {};
  late List _reviewsList = [];
  String _imageUrl = '';
  TabController? _tabController;
  bool imgVisibility = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
    _tabController?.addListener(() {
      if (_tabController?.index == 0) {
        imgVisibility = true;
      } else {
        imgVisibility = false;
      }

      setState(() {});

    });

    setState(() {
      _spotInfo = widget.spotInfo;
      _reviewsList = widget.reviewsList;
    });
    // Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // // Firebase Storageのインスタンスを初期化
    // _storage = FirebaseStorage.instance;
    // _firestore = FirebaseFirestore.instance;
    // 画像のダウンロードURLを取得
    // _getData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
  // Future<void> _getReviews(List reviews) async {
  //   // 画像のダウンロードURLを取得
  //   CollectionReference collection = _firestore.collection('Reviews');
  //   List getReviews = [];
  //   for (var i = 0; i < reviews.length; i++) {
  //     DocumentSnapshot snapshot = await collection.doc(reviews[i]).get();
  //     getReviews.add(snapshot.data() as Map<String, dynamic>);
  //   }

  //   setState(() {
  //     reviewsList = getReviews;
  //   });
  // }
  // Future<void> getImageUrl(String imagePath) async {
  //   // 画像のダウンロードURLを取得
  //   String downloadUrl = await _storage.ref().child(imagePath).getDownloadURL();
  //   setState(() {
  //     _imageUrl = downloadUrl;
  //   });
  // }
  // Future<void> _getData() async {
  //   DocumentSnapshot snapshot = await _firestore.collection('Spots').doc(spotId).get();
  //   print(snapshot.data());
  //   setState(() {
  //     spot_info = snapshot.data() as Map<String, dynamic>; // フィールド名に適切なものを使用してください
  //   });
  //   getImageUrl(spot_info["images"][0]);
  //   _getReviews(spot_info["reviews"]);
  // }
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
        actions: [
          Visibility(
            visible: true,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:5),
                  child: const Text(
                    'Check!',
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
                child: _spotInfo["imageUrl"] != ''
                  ? Image(image: CachedNetworkImageProvider(_spotInfo["imageUrl"]))
                  : const Center(child:CircularProgressIndicator()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _spotInfo["name"] != null
                  ? _spotInfo["name"]
                  : "...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


              // タブバー
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '概要'),
                  Tab(text: '口コミ'),
                  Tab(text: '地図'),
                ],
              ),
              // タブビュー
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              _spotInfo["explanation"] != null
                                ? _spotInfo["explanation"]
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
                                        _spotInfo["address"] != null
                                          ? _spotInfo["address"]
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
                                        _spotInfo["website"] != null
                                          ? _spotInfo["website"]
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
                                        _spotInfo["openHours"] != null
                                          ? _spotInfo["openHours"]
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
                                        _spotInfo["admissionFee"] != null
                                          ? _spotInfo["admissionFee"]
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
                    ListView.separated(
                      itemCount: _reviewsList.length,
                      itemBuilder: (context, int index) {
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
                                        color: (i < _reviewsList[index]["star"].round()) ? Colors.orange : Colors.grey,
                                        size: 20,
                                      )
                                  ],),
                                  SizedBox(width: 10,),
                                  Text(_reviewsList[index]["star"].toString(), style: TextStyle(fontSize: 18),),
                                ]
                              ),
                              SizedBox(height: 2,),
                              Text(
                                _reviewsList[index]["title"],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text(
                                _reviewsList[index]["message"]
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
                    Container(child:Text("ここにマップをのせる"), color: Colors.red,)
                  ],
                ),
              ),


          ],
        ),
      ),
    );
  }
}