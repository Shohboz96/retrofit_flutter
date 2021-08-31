import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retrofit_flutter/network/api_service.dart';

import 'entity/posts.dart';

class PostItemPage extends StatefulWidget {
  int postId;

  PostItemPage({Key? key, required this.postId}) : super(key: key);

  @override
  _PostItemPageState createState() => _PostItemPageState(postId);
}

class _PostItemPageState extends State<PostItemPage> {
  final int id;
  late final Future<Posts> posts;

  _PostItemPageState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiService apiService = ApiService(dio.Dio());
    posts = apiService.getPost(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chopper Blog'),
        ),
        body: FutureBuilder<Posts>(
            future: posts,
            builder: (context, AsyncSnapshot<Posts> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                    ),
                  );
                }
                final post = snapshot.data!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        post.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(post.body),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
