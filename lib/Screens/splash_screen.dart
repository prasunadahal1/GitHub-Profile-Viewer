import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/dashboard_provider.dart';
import '../Routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
         WidgetsBinding.instance.addPostFrameCallback((_) async {
            final session = Provider.of<DashboardProvider>(
              context,
           listen: false,
             );
            await session.loadSession();
            if (session.refreshToken!=null){
              await session.getCurrentUser();
              Navigator.pushNamed(context, Routes.dashboardScreen);
            }else{
              Navigator.pushNamed(context, Routes.loginScreen);
            }
         },
         );
    // provider.postData(provider.namecontroller.value.text, provider.passwordcontroller.value.text, context);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds:6),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Image.asset('Assets/git_image-removebg-preview.png'),
    );
  }
}