import "package:flutter/material.dart";

class SpotInformationPage extends StatefulWidget {
  const SpotInformationPage({super.key});

  @override
  State<SpotInformationPage> createState() => _SpotInformationPageState();
}

class _SpotInformationPageState extends State<SpotInformationPage>
     with SingleTickerProviderStateMixin  {
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
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
                child: Image.asset("images/hetumiya.jpg")
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "ここにタイトルが入る",
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
                              "説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる",
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
                                      Text("神奈川県横浜市")
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
                                      Text("https://www.google.com")
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
                                      Text("12:00 ~ 18:00")
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
                                      Text("入場料 120円")
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
                      itemCount: 5,
                      itemBuilder: (context, int position) {
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
                                        color: (i < 4) ? Colors.orange : Colors.grey,
                                        size: 20,
                                      )
                                  ],),
                                  SizedBox(width: 10,),
                                  Text("4.5", style: TextStyle(fontSize: 18),),
                                ]
                              ),
                              SizedBox(height: 2,),
                              Text(
                                "口コミタイトル",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text(
                                "口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ口コミ"
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