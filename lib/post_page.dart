import "package:flutter/material.dart";

class postPage extends StatefulWidget {
  const postPage({super.key});

  @override
  State<postPage> createState() => _postPageState();
}

class _postPageState extends State<postPage> {
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
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:5),
                child: const Text(
                  '投稿',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
            ),
          ),

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "サムネイル",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffdddddd)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Icon(Icons.add_circle, color: Colors.black38),
                  ),
                ),
              ),
              Text(
                "画像",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffdddddd)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:50, horizontal:80),
                    child: Icon(Icons.add_circle, color: Colors.black38),
                  ),
                ),
              ),
              Text(
                "概要",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: "概要",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '住所',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ホームページ',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '営業時間',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '料金',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}