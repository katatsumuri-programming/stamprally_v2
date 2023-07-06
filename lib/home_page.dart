import 'package:flutter/material.dart';
import 'package:stamprally_v2/project_information_page.dart';
import 'package:stamprally_v2/post_page.dart';
import 'package:stamprally_v2/spot_information_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int stampNum = 10;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.all(10),
                hintText: '検索',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, //色
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    "合計スタンプ",
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  const Spacer(),
                  Text(
                    stampNum.toString(),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Flexible(
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (context, int position) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset("images/hetumiya.jpg")
                        ),
                        const SizedBox(height: 6,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "ここにタイトルを入力",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                              InkWell(
                                child: const Icon(Icons.library_books_outlined, color: Colors.grey, size: 25,),
                                onTap: () {

                                },
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            "説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる",
                            style: TextStyle(
                              fontSize: 13
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(children: [
                                for (int i = 0; i < 5; i++)
                                  Icon(
                                    Icons.star,
                                    color: (i < 4) ? Colors.orange : Colors.grey,
                                  )
                              ],),
                              Text("4.5", style: TextStyle(fontSize: 20),),
                              const SizedBox(width: 15,),
                              Icon(Icons.chat, color: Colors.grey, size: 17,),
                              const SizedBox(width: 5,),
                              Text("5000人", style: TextStyle(fontSize:14)),
                              const SizedBox(width: 15,),
                              Icon(Icons.bookmark, color: Colors.grey, size: 17,),
                              const SizedBox(width: 5,),
                              Text("5000人", style: TextStyle(fontSize:14))
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999999),
                                    border: Border.all(color: Colors.blue),

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:5, horizontal:12),
                                    child: Text(
                                      "#グルメ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {

                                },
                              ),
                            )
                          ],
                        )
                      ]
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //     builder: (context) => SpotInformationPage(id:"KIBf5dQHAxQELOSbU8IR"),
                      //     //以下を追加
                      //     fullscreenDialog: true,
                      //   )
                      // );
                    },
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
          )

        ],
      ),

    );
  }
}