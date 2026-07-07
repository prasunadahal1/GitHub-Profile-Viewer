import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class UserProfileProvider extends ChangeNotifier{
  List<Map<String,dynamic>> _followersList=[];
  List <Map<String,dynamic>> get followersList=> _followersList;

  List<Map<String,dynamic>> _followingList=[];
  List <Map<String,dynamic>> get followingList=> _followingList;

  String? _accessToken=dotenv.env['GITHUB_TOKEN'];
  String? get accessToken=>_accessToken;

  Future<void> getFollowers( String keyword) async{
    try{
      Response response=await Dio().get("https://api.github.com/users/$keyword/followers",
        options: Options(
            headers: {
              'Authorization':'Bearer $_accessToken',
              "Accept": "application/vnd.github+json",
              // 'Authorization':'Bearer ${dotenv.env['GITHUB_TOKEN']}',
            }
        ),
      );
      if(response.statusCode==200 || response.statusCode==201){
        _followersList=List<Map<String, dynamic>>.from(response.data);
      }else{
        print("data not found");
      }
    } on DioException catch(e){
      print('Error $e');
    }
    notifyListeners();
  }
  Future<void> getFollowing( String keyword) async{
    try{
      Response response=await Dio().get("https://api.github.com/users/$keyword/following",
        options: Options(
            headers: {
              'Authorization':'Bearer $_accessToken',
              "Accept": "application/vnd.github+json",
              // 'Authorization':'Bearer ${dotenv.env['GITHUB_TOKEN']}',
            }
        ),
      );
      if(response.statusCode==200 || response.statusCode==201){
        _followingList=List<Map<String, dynamic>>.from(response.data);
      }else{
        print("data not found");
      }
    } on DioException catch(e){
      print('Error $e');
    }
    notifyListeners();
  }
}