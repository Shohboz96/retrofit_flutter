// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PostsDao? _postsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `posts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `title` TEXT NOT NULL, `body` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PostsDao get postsDao {
    return _postsDaoInstance ??= _$PostsDao(database, changeListener);
  }
}

class _$PostsDao extends PostsDao {
  _$PostsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _postsInsertionAdapter = InsertionAdapter(
            database,
            'posts',
            (Posts item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Posts> _postsInsertionAdapter;

  @override
  Stream<List<Posts>> getAllPosts() {
    return _queryAdapter.queryListStream('SELECT * FROM posts',
        mapper: (Map<String, Object?> row) => Posts(
            id: row['id'] as int,
            title: row['title'] as String,
            body: row['body'] as String),
        queryableName: 'posts',
        isView: false);
  }

  @override
  Future<void> deleteAllPosts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM posts');
  }

  @override
  Future<void> deletePost(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Posts WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertPosts(List<Posts> posts) async {
    await _postsInsertionAdapter.insertList(posts, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertPost(Posts posts) async {
    await _postsInsertionAdapter.insert(posts, OnConflictStrategy.replace);
  }
}
