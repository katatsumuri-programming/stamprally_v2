import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stamprally_v2/main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String email = "";
  String password = "";
  String infoText = "";

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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '新規登録',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 30,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'メールアドレス',
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 30,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'パスワード',
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(height: 20,),
            Text(
              infoText,
              style: TextStyle(
                color: Colors.red
              ),
            ),
            SizedBox(height: 30,),
            OutlinedButton(
              child: Text('新規登録'),

              onPressed: () async {
                try {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  isLoggedIn = true;

                  final _uid = auth.currentUser?.uid;
                  await postData('/post/user/create', {'uid':_uid});
                  var infoBox = await Hive.openBox('info_cache');
                  await infoBox.deleteFromDisk();
                  await Hive.openBox('info_cache');

                  List userIdData = await getData('/get/user', {'id':_uid});
                  userId = userIdData[0]['id'];
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return MyHomePage();
                    }),
                  );
                } catch (e) {
                  print(e);
                  // ログインに失敗した場合
                  setState(() {
                    infoText = "ログインに失敗しました：${e.toString().replaceFirst(RegExp(r'\[.+?\]'), '')}";
                  });
                }
              },
            )
          ]
        ),
      )
    );
  }
}