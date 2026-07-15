 import 'package:flutter/material.dart';
 import 'package:dio/dio.dart';
import 'package:github_profile_viewer/services/auth_interceptors.dart';

 class DioClient {
   static final Dio dio = Dio(
     BaseOptions(
       baseUrl: "https://dummyjson.com",
       connectTimeout: const Duration(seconds: 10),
       receiveTimeout: const Duration(seconds: 10),
       headers: {
         "Content-Type": "application/json",
       },
     ),
   )..interceptors.add(AuthInterceptors());
 }