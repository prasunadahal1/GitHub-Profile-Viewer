import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:github_profile_viewer/services/dio_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Routes/app_routes.dart';
import 'package:app_links/app_links.dart';

class DashboardProvider extends ChangeNotifier{
  static const _storage=FlutterSecureStorage();
  DashboardProvider(){
    loadRecentSearch();
  }

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController get namecontroller => _namecontroller;

  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController get passwordcontroller => _passwordcontroller;

  Map<String,dynamic> _user={};
  Map<String,dynamic> get user=>_user;

  List<String> _recentUserList=[];
  List<String> get recentUserList=>_recentUserList;

  Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;

  TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  String? _accessToken=dotenv.env['GITHUB_TOKEN'];
  String? get accessToken=>_accessToken;

  String? _Token;
  String? get Token=>_Token;

  String? _refreshToken;
  String? get refreshToken=>_refreshToken;

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

 void getName(int index){
   _searchController.text=_recentUserList[index];
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

   if(await launchUrl(url)){
     await launchUrl(url,mode: LaunchMode.inAppBrowserView);
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
       // await saveRecentSearch(_user["login"]);
     }else{
       print("data not found");
     }
   } on DioException catch(e){
   print('Error $e');
   }
     notifyListeners();
  }

  Future<void> loadRecentSearch() async{
   final prefs= await SharedPreferences.getInstance();
   _recentUserList= prefs.getStringList("Search History")?? [];
   notifyListeners();
  }

  Future<void>saveRecentSearch(String username)async{
  final prefs= await SharedPreferences.getInstance();

  _recentUserList.remove(username);//removes duplicates
  _recentUserList.insert(0,username);//add latest search at the top
    if(_recentUserList.length>10){  //keeps only last 10 searches
      _recentUserList.removeLast();  //removes form the last
    }
    await prefs.setStringList("search_history", _recentUserList);
    notifyListeners();
  }

  Future<void> clearRecentSearch()async{
   final prefs=await SharedPreferences.getInstance();
   await prefs.remove("search_history");
   _recentUserList.clear();
   notifyListeners();
  }

  Future<void> postData(String username,String password,BuildContext context)async{
  try {
    Response response = await DioClient.dio.post("/auth/login",
      data: {
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      _Token = data['accessToken'];
      _refreshToken = data['refreshToken'];
      _data = data;
      await setSession(_Token!);
      await setRefreshSession(_refreshToken!);
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.dashboardScreen);
      }
    }
  } on DioException catch(e){
    print('Error $e');
  }
    notifyListeners();
  }

  Future<void> getCurrentUser()async{
    Response response=await DioClient.dio.get("/auth/me");
    if(response.statusCode==200 || response.statusCode==201){
      final data =response.data;
      _data=data;
      notifyListeners();
    }else{
      await clearSession();
    }
    notifyListeners();
  }

  // Future<void> refreshSession(BuildContext context)async{
  //  try{
  //    Response response =await DioClient.dio.post("/auth/refresh",
  //    data: {
  //      'refreshToken': _refreshToken,
  //      'expiresInMins': 30,
  //    },
  //    );
  //    if (response.statusCode == 200 || response.statusCode == 201) {
  //      Navigator.push(
  //          context, MaterialPageRoute(builder: (context) => MainScreen()));
  //    }
  //  } on DioException catch(e){
  //    print('Error $e');
  //  }
  //  notifyListeners();
  // }

  Future<void> setSession(String token) async {
    await _storage.write(key: "accessToken", value: token);
    _Token = token;
    notifyListeners();
  }

  Future<void> setRefreshSession(String refreshToken) async {
    await _storage.write(key: "refreshToken", value: refreshToken);
    _refreshToken = refreshToken;
    notifyListeners();
  }

  Future<void> loadSession() async {
    final response = await Future.wait([
      _storage.read(key: 'accessToken'),
      _storage.read(key: 'refreshToken'),
    ]);
    _Token = response[0];
    _refreshToken = response[1];
    notifyListeners();
  }

  Future<void> clearSession() async {
    _Token = null;
    _refreshToken = null;
    await Future.wait([
      _storage.delete(key: 'accessToken'),
      _storage.delete(key: 'refreshToken'),
    ]);
    notifyListeners();
  }
  static configDeepLink(BuildContext context)async{
   final appLinks=AppLinks();
   final initialUri = await appLinks.getInitialLink();
   if (initialUri != null && initialUri.host == "github-login") {
     if (context.mounted) {
       Navigator.pushNamed(context, Routes.dashboardScreen);
     }
   }
   appLinks.uriLinkStream.listen((uri){
     if (uri.host=="github-login"){
       if(context.mounted){
         Navigator.pushNamed(context, Routes.dashboardScreen);
       }
     }
   });
  }

  final supabase=Supabase.instance.client;
  continueWithGoogle(BuildContext context)async{
   try{
     GoogleSignIn signIn=GoogleSignIn.instance;
     await signIn.initialize(
       serverClientId: dotenv.env['WEB_CLIENT'],
       clientId: Platform.isAndroid? dotenv.env['ANDROID_CLIENT']:
         dotenv.env['IOS_CLIENT']
     );
     GoogleSignInAccount account = await signIn.authenticate();
     String idToken=account.authentication.idToken??"";
     final authorization=await account.authorizationClient.authorizationForScopes(['email','profile'])?? await account.authorizationClient.authorizeScopes(['email','profile']);

     final result = await supabase.auth.signInWithIdToken(
         provider: OAuthProvider.google,
         idToken: idToken,
         accessToken: authorization.accessToken
     );
     if (result.user!= null && result.session!=null){
       Navigator.pushNamed(context, Routes.dashboardScreen);
     }
   }on GoogleSignInException catch(e){
     if (e.code == GoogleSignInExceptionCode.canceled) {
       print("User cancelled ya reauth failed: ${e.description}");
     }
   }
  }

  continueWithGithub()async{
    await supabase.auth.signInWithOAuth(
      OAuthProvider.github,
      redirectTo: 'code://github-login', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode: LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }
}