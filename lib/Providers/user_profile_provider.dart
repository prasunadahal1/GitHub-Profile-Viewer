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

  List<Map<String,dynamic>> _contributorsList=[];
  List<Map<String,dynamic>> get contributorsList=> _contributorsList;

  Map<String, dynamic> _languages = {};
  Map<String, dynamic> get languages => _languages;


  String _totalStarCount = "0";
  String get totalStarCount => _totalStarCount;

  String? _accessToken=dotenv.env['GITHUB_TOKEN'];
  String? get accessToken=>_accessToken;

  String? _name;
  String? get name=> _name;

  String? _description;
  String? get description=> _description;

  String? _star;
  String? get star=> _star;

  String? _forks;
  String? get forks=> _forks;

  String? _issues;
  String? get issues=> _issues;

  String? _watcher;
  String? get watcher=> _watcher;


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
          Colors.grey;
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

  void setRepoData(String name,String description,String star,String forks,String issues,String watcher ){
    _name=name;
    _description=description;
    _star=star;
    _forks=forks;
    _issues=issues;
    _watcher=watcher;

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
        int total = 0;

        for (var repo in _repoList) {
          total += (repo['stargazers_count'] ?? 0) as int;
        }

        _totalStarCount = total.toString();
      }else{
        print("data not found");
      }
    } on DioException catch(e){
      print('Error $e');
    }
    notifyListeners();
  }

  Future<void> getContributors(String keyword, String repoName) async {
    try {
      // Prefer the exact owner/repo from the already-fetched repo list so we
      // don't build a bad URL from search text (spaces, wrong casing, etc.).
      Map<String, dynamic>? matchedRepo;
      for (final repo in _repoList) {
        if (repo['name'] == repoName || repo['name'] == _name) {
          matchedRepo = repo;
          break;
        }
      }

      final String owner = ((matchedRepo?['owner']?['login'] as String?) ?? keyword)
          .trim();
      final String repo =
          ((matchedRepo?['name'] as String?) ?? repoName).trim();

      if (owner.isEmpty || repo.isEmpty) {
        _contributorsList = [];
        notifyListeners();
        return;
      }

      // Use GitHub's contributors_url when available, otherwise build the path.
      final String url = (matchedRepo?['contributors_url'] as String?) ??
          "https://api.github.com/repos/$owner/$repo/contributors";

      final headers = <String, dynamic>{
        "Accept": "application/vnd.github+json",
      };
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_accessToken';
      }

      Response response = await Dio().get(
        url,
        options: Options(headers: headers),
      );

      // Empty repos return 204 with no body.
      if (response.statusCode == 204) {
        _contributorsList = [];
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        _contributorsList =
            List<Map<String, dynamic>>.from(response.data ?? []);
      } else {
        _contributorsList = [];
        print("data not found");
        print("Owner: $owner");
        print("Repo : $repo");
      }
    } on DioException catch (e) {
      _contributorsList = [];
      print("Status: ${e.response?.statusCode}");
      print("Body: ${e.response?.data}");
    }
    notifyListeners();
  }

  Future<void> getLanguages(String keyword, String repoName) async {
    try {
      Response response = await Dio().get(
        "https://api.github.com/repos/$keyword/$repoName/languages",
        options: Options(
          headers: {
            "Authorization": "Bearer $_accessToken",
            "Accept": "application/vnd.github+json",
            // 'Authorization':'Bearer ${dotenv.env['GITHUB_TOKEN']}',
          },
        ),
      );

      if (response.statusCode == 200) {
        _languages = Map<String, dynamic>.from(response.data);
      } else {
          print('data not found');
      }
    } on DioException catch (e) {
      print('Error $e');
    }
    notifyListeners();
  }
}