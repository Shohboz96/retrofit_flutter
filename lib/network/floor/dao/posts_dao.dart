
import 'package:floor/floor.dart';
import 'package:retrofit_flutter/network/entity/posts.dart';

@dao
abstract class PostsDao{

  @Query('SELECT * FROM posts')
  Stream<List<Posts>> getAllPosts();

  @Query('DELETE FROM posts')
  Future<void> deleteAllPosts();

  @Query('DELETE FROM posts WHERE id =:id')
  Future<void> deletePost(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPosts(List<Posts> posts);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPost(Posts posts);

}