import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:github_profile_viewer/Screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'Routes/app_routes.dart';
import 'Routes/app_routes_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> DashboardProvider()),
        ChangeNotifierProvider(create: (context)=> UserProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: Routes.dashboardScreen,
        onGenerateRoute: AppRoutesGenerator.generateRoute,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: DashboardScreen(),
      ),
    );
  }
}


