import 'package:flutter/material.dart';
import 'package:stamprally_v2/home_page.dart';
import 'package:stamprally_v2/login_page.dart';
import 'package:stamprally_v2/main.dart';
import 'package:stamprally_v2/my_rewards_page.dart';
import 'package:stamprally_v2/history_page.dart';
import 'package:stamprally_v2/login_page.dart';
import 'package:stamprally_v2/signup_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
            Visibility(
              visible: isLoggedIn,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
            Visibility(
              visible: !isLoggedIn,
              child: Column(
                children: [
                  ListTile(
                    title: const Text("新規登録"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => SignupPage(),
                          //以下を追加
                          fullscreenDialog: true,
                        )
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("サインイン"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => LoginPage(),
                          //以下を追加
                          fullscreenDialog: true,
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("問い合わせ"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final url = Uri.parse('https://forms.gle/QCseXaFzHhdyDBxF8');
                launchUrl(url);
              },
            ),
            Visibility(
              visible: isLoggedIn,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        child: const Text("ログアウト"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          isLoggedIn = false;
                          userId = -1;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return MyHomePage();
                            }),
                          );
                        },
                      ),
                    )
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        child: const Text("アカウントを削除"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          var ret = await showDialog(
                            context: context,
                            // (3) AlertDialogを作成する
                            builder: (context) => AlertDialog(
                              content: Text("本当にアカウントを削除しますか"),
                              // (4) ボタンを設定
                              actions: [
                                TextButton(onPressed: () => {
                                  //  (5) ダイアログを閉じる
                                  Navigator.pop(context,false)
                                },
                                    child: Text("キャンセル")
                                ),
                                TextButton(onPressed: (){
                                  Navigator.pop(context,true);
                                  },
                                  child: Text("はい")
                                ),
                              ],
                            )
                          );
                          if(ret != null) {
                            if (ret == true) {
                              print(userId);
                              await FirebaseAuth.instance.currentUser?.delete();

                              await postData('/post/user/delete', {'user_id':userId});

                              var infoBox = await Hive.openBox('info_cache');
                              await infoBox.deleteFromDisk();
                              await Hive.openBox('info_cache');

                              userId = -1;
                              isLoggedIn = false;

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                                  return MyHomePage();
                                }),
                              );
                            }
                          }
                        },
                      ),
                    )
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}