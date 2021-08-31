import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit_flutter/network/entity/posts.dart';


part 'api_service.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com/posts')
abstract class ApiService{

  factory ApiService(Dio dio,{String? baseUrl}){
    dio.options = BaseOptions(
    receiveTimeout: 60000,
    connectTimeout: 60000,
    contentType: 'application-json',
    );
    return _ApiService(dio, baseUrl:baseUrl);

}

  @GET('')
  Future<List<Posts>> getAllPosts();

  @GET('/{id}')
  Future<Posts> getPost(@Path('id') int id);
}