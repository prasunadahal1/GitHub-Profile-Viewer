import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DashboardProvider extends ChangeNotifier{
  Map<String,dynamic> _user={};
  Map<String,dynamic> get user=>_user;

  String? _accessToken=dotenv.env['GITHUB_TOKEN'];
  String? get accessToken=>_accessToken;


  late bool _isVisible=false;
  bool get isVisible=> _isVisible;
 void visible(){
    _isVisible = !_isVisible;
    notifyListeners();
 }
  Future<void> getData( String keyword) async{
   try{
     Response response=await Dio().get("https://api.github.com/search/users?q=$keyword",
      options: Options(
        headers: {
          'Authorization':'Bearer $_accessToken',
          "Accept": "application/vnd.github+json",
          // 'Authorization':'Bearer ${dotenv.env['GITHUB_TOKEN']}',
        }
      ),
     );
     if(response.statusCode==200 || response.statusCode==201){
       _user=response.data;
     }else{
       print("data not found");
     }
   } on DioException catch(e){
   print('Error $e');
   }
     notifyListeners();
  }

 // void searchFilter(String keyword){
 //   final username = keyword.trim();
 //
 //   if (username.isEmpty) return;
 //   getData(username);
 //   notifyListeners();
 // }
}