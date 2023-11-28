import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:stamprally_v2/main.dart';
import 'package:stamprally_v2/spot_information_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PostReview extends StatefulWidget {
  const PostReview({super.key});

  @override
  State<PostReview> createState() => _PostReviewState();
}

class _PostReviewState extends State<PostReview> {
  int reviewStar = 0;
  String _message = '';
  String _title = '';
  @override
  Widget build(BuildContext context) {
    return Consumer<SpotInformationModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Image.asset(
              'images/appBarImage.png',
              height: 38,
            )
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right:30.0, top: 15, bottom: 15, left:30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.spotInfo["title"] != null
                        ? model.spotInfo["title"]
                        : "...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      child: Text("投稿"),
                      onPressed: () async {
                        if (!(_message == '' || _title == '' || reviewStar == 0)) {
                          await postData('/post/review', {'title':_title, 'message':_message, 'star':reviewStar , 'spot_id': model.spotInfo['id']});

                          var infoBox = Hive.box('info_cache');
                          await infoBox.delete(getPendingUri('/get/spots/reviews', {'spot_id':model.spotInfo['id'], 'limit':'0'}).toString());

                          List _reviewsList = await getData('/get/spots/reviews', {'spot_id':model.spotInfo['id'], 'limit':'0'});
                          Provider.of<SpotInformationModel>(context, listen: false).updateReviewsList(_reviewsList);
                          Navigator.of(context).pop(false);
                        }
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:6),
                          child: Icon(
                            (i <= reviewStar) ? Icons.star : Icons.star_outline,
                            color: (i <= reviewStar) ? Colors.orange : Colors.grey,
                            size: 40,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            reviewStar = i;
                          });
                        },
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                     TextField(
                      decoration: InputDecoration(
                        hintText: 'タイトル',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        _title = text;
                      },
                    ),
                    SizedBox(height:10),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'クチコミをここに書く\n\n\n\n\n',
                          border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        _message = text;
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      }
    );
  }
}