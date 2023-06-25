import 'package:flutter/material.dart';
import 'package:stamprally_v2/my_rewards_page.dart';
import 'package:stamprally_v2/history_page.dart';


class OthersPage extends StatefulWidget {
  const OthersPage({super.key});

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ここにアカウント名",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "xxxxxxxxxxx@xxxx.xx.xx",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),
                    ),
                  )
                ]
              ),
            ),
            Divider(height: 1,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey, //色
                                spreadRadius: 0,
                                blurRadius: 3
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.redeem, size: 28,),
                                Text(
                                  "特典",
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => MyRewardsPage(),
                            //以下を追加
                            fullscreenDialog: true,
                          )
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey, //色
                                spreadRadius: 0,
                                blurRadius: 3
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.history, size: 28,),
                                Text(
                                  "履歴",
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => HistoryPage(),
                            //以下を追加
                            fullscreenDialog: true,
                          )
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
            ListTile(
              title: const Text("登録"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text("問い合わせ"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text("アカウントを削除"),
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}