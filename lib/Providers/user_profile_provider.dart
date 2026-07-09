import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';


class UserProfileProvider extends ChangeNotifier{
  List<Map<String,dynamic>> _followersList=[];
  List <Map<String,dynamic>> get followersList=> _followersList;

  List<Map<String,dynamic>> _followingList=[];
  List<Map<String,dynamic>> get followingList=> _followingList;

  List<Map<String,dynamic>> _repoList=[];
  List<Map<String,dynamic>> get repoList=> _repoList;

  String? _accessToken=dotenv.env['GITHUB_TOKEN'];
  String? get accessToken=>_accessToken;

  Color getLanguageColor(String? color){
    switch(color){
      case "Dart":
        return Color(0xff00B4AB);
        
      case "Java":
        return Color(0xffB07219);

      case "JavaScript":
        return Color(0xffF1E05A);
        
      case "TypeScript":
        return Color(0xff3178C6);
        
      case "Python":
        return Color(0xff3572A5);

      case "C++":
        return Color(0xffF34B7D);

      case "HTML":
        return Color(0xffE34C26);

      case"CSS":
        return Color(0xff563D7C);

        default:return
          Colors.black;
    }
  }
  
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

  Future<void> getRepo( String keyword) async{
    try{
      Response response=await Dio().get("https://api.github.com/users/$keyword/repos",
        options: Options(
            headers: {
              'Authorization':'Bearer $_accessToken',
              "Accept": "application/vnd.github+json",
              // 'Authorization':'Bearer ${dotenv.env['GITHUB_TOKEN']}',
            }
        ),
      );
      if(response.statusCode==200 || response.statusCode==201){
        _repoList=List<Map<String, dynamic>>.from(response.data);
      }else{
        print("data not found");
      }
    } on DioException catch(e){
      print('Error $e');
    }
    notifyListeners();
  }

}