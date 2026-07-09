import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardProvider extends ChangeNotifier{
  Map<String,dynamic> _user={};
  Map<String,dynamic> get user=>_user;

  TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  String? _accessToken=dotenv.env['GITHUB_TOKEN'];
  String? get accessToken=>_accessToken;

  String? _image ;
  String? get image=> _image ;

  String? _name;
  String? get name=> _name;

  String? _loginName;
  String? get loginName=> _loginName;

  String? _followers;
  String? get followers=> _followers;

  String? _following;
  String? get following=> _following;

  String? _value;
  String? get value=> _value;

  late bool _isVisible=false;
  bool get isVisible=> _isVisible;

 void visible(){
    _isVisible = !_isVisible;
    notifyListeners();
 }
  void setData(String image,String name,String loginName,String followers,String following,String value){
    _image=image;
    _name=name;
    _loginName=loginName;
    _followers=followers;
    _following=following;
    _value=value;
    notifyListeners();
  }
  Future<void> getUrl()async{
   final Uri url =Uri.parse(_user['html_url']);

   if(await canLaunchUrl(url)){
     await launchUrl(url,mode: LaunchMode.externalApplication);
   }else{
     throw Exception("sorry $url");
   }
   print("object");
   notifyListeners();
  }

  Future<void> getData( String keyword) async{
   try{
     Response response=await Dio().get("https://api.github.com/users/$keyword",
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

}