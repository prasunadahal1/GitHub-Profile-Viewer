import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:provider/provider.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final DashboardProvider provider = Provider.of<DashboardProvider>(context,listen: false);

  // @override
  // void dispose() {
  //   sessionProvider.namecontroller.dispose();
  //   sessionProvider.passwordcontroller.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              TextFormField(
                controller: provider.namecontroller,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: provider.passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    provider.postData(provider.namecontroller.text, provider.passwordcontroller.text,context);
                    // final session=SessionManagement.instance;
                    // session.setSession(sessionProvider.namecontroller.text,sessionProvider.passwordcontroller.text);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MainScreen(),
                    //   ),
                    // );
                  },
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                 provider.continueWithGoogle(context);
                },
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Image.asset("Assets/google-logo.jpg",height: 40,width:30),
                    SizedBox(width:5),
                    Text('Continue with google',style: TextStyle(fontSize: 15))
                  ],
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: (){
                provider.continueWithGithub();
                },
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Image.asset("Assets/git_image-removebg-preview.png",height: 40,width:30),
                    SizedBox(width:5),
                    Text('Continue with github',style: TextStyle(fontSize: 15))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}