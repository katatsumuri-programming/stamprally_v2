import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            Image.asset("images/hetumiya.jpg"),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ここに特典タイトル",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる説明を入れる",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:5),
                          child: const Text(
                            '申し込む',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}