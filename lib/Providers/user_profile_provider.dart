import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percent_indicator/multi_segment_linear_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:number_pagination/number_pagination.dart';


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

  int get totalLanguageBytes {
    if (_languages.isEmpty) return 0;
    return _languages.values.fold<int>(
      0,
          (sum, v) => sum + (v as num).toInt(),
    );
  }

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

  String? _htmlUrl;
  String? get htmlUrl=> _htmlUrl;

  bool _isloading=false;
  bool get isloading => _isloading;

  int _page=1;
  final int _limit=1;

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

      case"Rust":
        return Colors.brown;

      case"Swift":
        return Colors.orange;

      case"Kotlin":
        return Colors.purple;

      case"Ruby":
        return Colors.redAccent;

      case"C":
        return Colors.blueAccent;

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

  void setRepoData(String name,String description,String star,String forks,String issues,String watcher,String htmlUrl ){
    _name=name;
    _description=description;
    _star=star;
    _forks=forks;
    _issues=issues;
    _watcher=watcher;
    _htmlUrl=htmlUrl;
    notifyListeners();
  }

  Future<void> getRepoUrl()async{
    final Uri url =Uri.parse(_htmlUrl!);

    if(await launchUrl(url)){
      await launchUrl(url,mode: LaunchMode.inAppBrowserView);
    }else{
      throw Exception("sorry $url");
    }
    notifyListeners();
  }

  getRepo( String keyword,int page,int limit) async{
    try{
      Response response=await Dio().get("https://api.github.com/users/$keyword/repos?_page=$page&_limit=$limit",
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

Future<void> getPage(String keyword)async{
    _isloading=true;
    notifyListeners();
    try{
      _repoList=await getRepo(keyword, _page, _limit);
      if (repoList.isEmpty){
      }else {
        repoList.addAll(repoList);
        _page++;
      }
    }catch(e){
      print("error:$e");
    }finally{
      _isloading=false;
      notifyListeners();
    }
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

  void clearLanguage(){
    _languages.clear();//clear fetch data
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
        print(response.statusCode);
        print(response.data);
      } else {
          print('data not found');
      }
    } on DioException catch (e) {
      print('Error $e');
    }
    notifyListeners();
  }

  List<SegmentLinearIndicator> buildSegments(Map<String, dynamic> languageBytes) {
    if (languageBytes.isEmpty) return [];

    final total = totalLanguageBytes;
    if (total == 0) return [];

    final entries = languageBytes.entries.toList();
    final percents = entries
        .map((e) => (e.value as num).toDouble() / total)
        .toList();

    // Float division can sum to slightly over 1.0 (e.g. 1.0000000000000002).
    // Normalize so MultiSegmentLinearIndicator does not assert.
    final sum = percents.fold<double>(0, (a, b) => a + b);
    final scale = sum > 1.0 ? 1.0 / sum : 1.0;

    return List.generate(entries.length, (i) {
      return SegmentLinearIndicator(
        percent: percents[i] * scale,
        color: getLanguageColor(entries[i].key),
      );
    });
  }

}