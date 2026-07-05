import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../Screens/dashboard_screen.dart';
import '../Screens/user_profile_screen.dart';

class AppRoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case Routes.dashboardScreen:
        return MaterialPageRoute(
            builder: (_)=>const DashboardScreen()
        );
      case Routes.userProfileScreen:
        return MaterialPageRoute(
            builder: (_)=>const UserProfileScreen()
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Page Not Found"),
            ),
          ),
        );
    }
  }

}