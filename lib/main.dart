import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:retrofit_flutter/network/api_service.dart';

import 'network/entity/posts.dart';
import 'network/single_post_page.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final Future<List<Posts>> posts;

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService(dio.Dio());
    posts = apiService.getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Retrofit"),
      ),
      body: _builtBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  FutureBuilder<List<Posts>> _builtBody(BuildContext context) {
    return FutureBuilder<List<Posts>>(
        future: posts,
        builder: (context, AsyncSnapshot<List<Posts>> snapshot) {
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
            return _buildPosts(context,snapshot.data!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }


  ListView _buildPosts(BuildContext context, List<Posts> posts) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, int index) {
          return Card(
            elevation: 4,
            child: ListTile(
                title: Text(
                  posts[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(posts[index].body),
                onTap: () {
                  _navigatePosts(context, posts[index].id);
                }),
          );
        });
  }

  void _navigatePosts(BuildContext context, int id) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostItemPage(postId: id,),),);
  }
}
