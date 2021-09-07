
import 'package:floor/floor.dart';
import 'package:retrofit_flutter/network/entity/posts.dart';

import 'dao/posts_dao.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'app_database.g.dart';

@Database(version: 1, entities: [Posts])
abstract class AppDatabase extends FloorDatabase{
  PostsDao get postsDao;
}