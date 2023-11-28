import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stamprally_v2/home_page.dart';
import 'package:stamprally_v2/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              'サインイン',
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
              child: Text('サインイン'),

              onPressed: () async {
                try {
                  // メール/パスワードでログイン
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  isLoggedIn = true;

                  final _uid = auth.currentUser?.uid;
                  List userIdData = await getData('/get/user', {'id':_uid});
                  userId= userIdData[0]['id'];
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