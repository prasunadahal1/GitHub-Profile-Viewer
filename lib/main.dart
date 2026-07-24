import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:github_profile_viewer/Screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Routes/app_routes.dart';
import 'Routes/app_routes_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url:dotenv.env['SUPABASE_URL']!,
      anonKey:dotenv.env['SUPABASE_ANON_KEY']!
  );
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
        initialRoute: Routes.splashScreen,
        onGenerateRoute: AppRoutesGenerator.generateRoute,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: DashboardScreen(),
      ),
    );
  }
}


