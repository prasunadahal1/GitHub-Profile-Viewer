import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github_profile_viewer/services/dio_client.dart';

class AuthInterceptors extends Interceptor{
  final DashboardProvider _storage=DashboardProvider();


}