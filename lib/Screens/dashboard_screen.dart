import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/first_provider.dart';
import 'package:provider/provider.dart';

import '../Routes/app_routes.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Consumer<FirstProvider>(
      builder:(context,provider,_){
        return  CustomScrollView(
            slivers:[
              SliverAppBar(
                title: Text('Welcome'),
                actions: [
                  IconButton(onPressed: (){
                    provider.visible();
                  }, icon:Icon(Icons.search)),
                  SizedBox(width: 15),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://img.magnific.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg?semt=ais_hybrid&w=740&q=80"),
                  ),
                  SizedBox(width:25),
                ],
              ),
              SliverToBoxAdapter(
                child: SizedBox(height:20),
              ),
              SliverToBoxAdapter(
                child:Visibility(
                  visible: provider.isVisible,
                  child: TextFormField(
                    onChanged: (value) {
                    },
                    decoration: InputDecoration(
                      hintText: 'Search GitHub',
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          color: Color(0xFF84C5A5),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Color(0xFF84C5A5),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height:10),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 5,
                    children: [
                      Text('People',style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: (){
                          Navigator.pushNamed(context,Routes.userProfileScreen);
                        },
                        leading: CircleAvatar(backgroundImage: NetworkImage("https://img.magnific.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg?semt=ais_hybrid&w=740&q=80"),),
                        title: Text('Prasuna Dahal',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
                        subtitle: Text('prasunadahal1',style:TextStyle(fontSize:15,fontWeight: FontWeight.w400),),
                      ),
                    ],
                  ),
                ),

              )
            ]
        );
      },
    ),
    );
  }
}
