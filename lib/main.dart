import 'package:dio/dio.dart' as dio;
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:retrofit_flutter/network/api_service.dart';
import 'package:retrofit_flutter/network/floor/app_database.dart';
import 'package:retrofit_flutter/network/floor/dao/posts_dao.dart';

import 'network/entity/posts.dart';
import 'network/single_post_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder("name").build();
  final dao = database.postsDao;

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(
        dao: dao,
      )));
}

class MainPage extends StatefulWidget {
  final PostsDao dao;

  const MainPage({Key? key, required this.dao}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState(dao);
}

class _MainPageState extends State<MainPage> {
  late final List<Posts> posts;
  final PostsDao dao;

  _MainPageState(this.dao);

  @override
  void initState() {
    loadData(dao);
    // ApiService apiService = ApiService(dio.Dio());
    // posts = apiService.getAllPosts();
    // dao.insertPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Retrofit and Database"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Posts>>(
          stream: widget.dao.getAllPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              var list = snapshot.data!;
              return createPosts(context, list);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {},
      // ),
    );
  }

  Widget createPosts(BuildContext context, List<Posts> list) {

    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, int index) {
          return Card(
            elevation: 6,
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Slidable(
              child: ListTile(
                title: Text(
                  list[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Text(
                  list[index].body,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: [
                IconSlideAction(
                  caption: 'update',
                  color: Colors.blue,
                  icon: Icons.update,
                  onTap: () async {
                    final post = Posts(
                        id: list.length + 1, title: Faker().address.city(), body: Faker().company.name());
                    await dao.insertPost(post);
                  },
                ),
                IconSlideAction(
                  caption: 'delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    await dao.deletePost(list[index].id);
                  },
                ),
              ],
            ),
          );
        });
  }

  // FutureBuilder<List<Posts>> _builtBody(BuildContext context) {
  //   return FutureBuilder<List<Posts>>(
  //       future: posts,
  //       builder: (context, AsyncSnapshot<List<Posts>> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           if (snapshot.hasError) {
  //             // final ls = widget.dao.getAllPosts() as List<Posts>;
  //             // if(ls.isNotEmpty){
  //             //   return _buildPosts(
  //             //       context,ls);
  //             // }
  //             // else
  //               return Center(
  //                 child: Text(
  //                   snapshot.error.toString(),
  //                   textAlign: TextAlign.center,
  //                   textScaleFactor: 1.5,
  //                 ),
  //               );
  //             // print('local size:${box.values}');
  //             // _buildPosts(context,HiveList(box));
  //           }
  //
  //           // widget.dao.insertPosts(snapshot.data!);
  //           return _buildPosts(context,snapshot.data!);
  //         } else {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //       });
  // }
  //
  //
  // ListView _buildPosts(BuildContext context, List<Posts> posts) {
  //
  //   return ListView.builder(
  //       itemCount: posts.length,
  //       itemBuilder: (context, int index) {
  //         return Card(
  //           elevation: 4,
  //           child: ListTile(
  //               title: Text(
  //                 posts[index].title,
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               subtitle: Text(posts[index].body),
  //               onTap: () {
  //                 _navigatePosts(context, posts[index].id);
  //               }),
  //         );
  //       });
  // }

  void _navigatePosts(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostItemPage(
          postId: id,
        ),
      ),
    );
  }

  void loadData(PostsDao dao) async {
    ApiService apiService = ApiService(dio.Dio());
    posts = await apiService.getAllPosts();
    dao.deleteAllPosts();
    await dao.insertPosts(posts);
    // await posts.then((value) => dao.insertPosts(value));
  }
}
