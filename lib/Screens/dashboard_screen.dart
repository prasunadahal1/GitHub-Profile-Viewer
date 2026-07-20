import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:github_profile_viewer/Screens/splash_screen.dart';
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
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: Text('Welcome'),
                actions: [
                  IconButton(
                    onPressed: () {
                      provider.visible();
                    },
                    icon: Icon(Icons.search, color: Colors.blue),
                  ),
                  SizedBox(width: 15),
                  PopupMenuButton<String>(
                    onSelected: (value)async{
                      if(value=="logout"){
                        await provider.clearSession();
                        print("logout");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()),
                              (route) => false,
                        );
                       // Navigator.pushNamed(context, Routes.splashScreen);
                       print("screen");
                      }
                    },
                    itemBuilder: (context)=>[
                      PopupMenuItem(
                        value: "logout",
                          child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Logout"),
                        ],
                      )
                      )
                    ],
                      child: Icon(Icons.more_vert, color: Colors.blue)),
                  // PopupMenuButton(
                  //   itemBuilder: (context)=>[
                  //     PopupMenuItem(
                  //         child: Text('Logout'))
                  //   ],
                  //   child: CircleAvatar(
                  //     radius: 20,
                  //     backgroundImage: NetworkImage(
                  //       "https://img.magnific.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg?semt=ais_hybrid&w=740&q=80",
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width:15),
                ],
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: provider.isVisible,
                  child: TextFormField(
                    controller: provider.searchController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Search GitHub',
                      suffixIcon: IconButton(
                        onPressed: () {
                          provider.getData(provider.searchController.value.text);
                        },
                        icon: Icon(Icons.search),
                      ),
                      fillColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'People',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.user.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 5,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Center(
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://img.magnific.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg?semt=ais_hybrid&w=740&q=80",
                                ),
                              ),
                              title: Text(
                                "not found",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "not found",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    onTap: () {
                      provider.setData(provider.user['avatar_url']?? "", provider.user['name']?? "No name",
                          provider.user['login']?? "", provider.user['followers'].toString(), provider.user['following'].toString(),provider.searchController.value.text);

                      provider.saveRecentSearch(provider.user["login"]);
                      print('search');
                      Navigator.pushNamed(context, Routes.userProfileScreen);
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        provider.user['avatar_url'] ?? "",
                      ),
                    ),
                    title: Text(
                      provider.user['name'] ?? "no name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      provider.user['login'] ?? "not found",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            'Recent Searches',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              provider.clearRecentSearch();
                            },
                            child: Text("Clear",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
                          ),
                        ],
                      )

                    ],
                  ),

                ),
              ),
              SliverToBoxAdapter(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal:0,),
                  physics:  NeverScrollableScrollPhysics(),
                  itemCount: provider.recentUserList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: GestureDetector(
                        onTap: (){
                         provider.getName(index);
                          print("hello");
                        },
                        child: ListTile(
                          title: Text( provider.recentUserList[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
