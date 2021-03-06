import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
part 'posts.g.dart';

@JsonSerializable()
@Entity(tableName: 'posts')
class Posts{
  @PrimaryKey(autoGenerate: true)
  // final int? userId;
  final int id;
  final String title;
  final String body;

  Posts({required this.id, required this.title, required this.body});

  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);
  Map<String, dynamic> toJson() => _$PostsToJson(this);

}