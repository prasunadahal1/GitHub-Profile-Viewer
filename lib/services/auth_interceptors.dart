import 'package:dio/dio.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github_profile_viewer/services/dio_client.dart';

class AuthInterceptors extends Interceptor{
  static const FlutterSecureStorage _storage=FlutterSecureStorage();

  @override
  Future<void>onRequest(options,handler)async{
    final Token =await _storage.read(key: "accessToken");
    if(Token != null && Token.isNotEmpty){
      options.headers["Authorization"]="Bearer $Token";
    }
    handler.next(options);
  }
  @override
  void onResponse(response,handler)async{
   handler.next(response);
   }
   @override
  Future<void> onError(err,handler)async{
    if (err.response?.statusCode==401){
      try{
        final refreshToken=await _storage.read(key: "refreshToken");
        if(refreshToken== null){
          return handler.next(err);
        }
        final response= await DioClient.dio.post("/auth/refresh",
        data: {
          "refreshToken":refreshToken,
          "expiresInMins": 30,
        });
        if (response.statusCode == 200 || response.statusCode == 201){
          final newAccessToken= response.data["accessToken"];
          await _storage.write(key: "accessToken", value: newAccessToken);

          final requestOptions = err.requestOptions;
          requestOptions.headers["Authorization"] = "Bearer $newAccessToken";

          final retryResponse = await DioClient.dio.fetch(requestOptions);
          return handler.resolve(retryResponse);
          // err.requestOptions.headers["Authorization"]="Bearer $newAccessToken";
          // return handler.resolve(await DioClient.dio.fetch(err.requestOptions));
        }


        }catch(_){
        await _storage.delete(key: "accessToken");
        await _storage.delete(key: "refreshToken");
      }
      }
    handler.next(err);
    }
   }


// Future<void> refreshSession(BuildContext context)async{
//    try{
//      Response response =await DioClient.dio.post("/auth/refresh",
//      data: {
//        'refreshToken': _refreshToken,
//        'expiresInMins': 30,
//      },
//      );
//      if (response.statusCode == 200 || response.statusCode == 201) {
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => MainScreen()));
//      }
//    } on DioException catch(e){
//      print('Error $e');
//    }
//    notifyListeners();
//   }