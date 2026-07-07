import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

import '../Routes/app_routes.dart';


class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late DashboardProvider provider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      body: Consumer<UserProfileProvider>(
        builder: (context, p, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                floating: true,
                pinned: true,
                leading: BackButton(color: Colors.black),
                actions: [
                  Icon(Icons.share_outlined, color: Colors.blue),
                  SizedBox(width: 10),
                  Icon(Icons.more_vert, color: Colors.blue),
                  SizedBox(width: 10),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              provider.image?? "",
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.name ?? "no name",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                provider.loginName ?? "",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 18,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Text(
                            provider.followers?? "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              p.getFollowers(provider.value!);
                              Navigator.pushNamed(context, Routes.followersScreen);
                            },
                            child: Text(
                              "followers",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Text(" • ", style: TextStyle(fontSize: 18)),
                          Text(
                            provider.following?? "",
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: (){
                              p.getFollowing(provider.value!);
                              Navigator.pushNamed(context, Routes.followingScreen);
                            },
                            child: Text(
                              "following",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                      Divider(),

                      ListTile(
                        onTap: () {},
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(Icons.book_outlined, color: Colors.white),
                        ),
                        title: Text("Repositories", style: TextStyle()),
                        trailing: Text(
                          provider.user['public_repos'].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Divider(),

                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.apartment_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text("Organizations"),
                        trailing: Text(
                          "0",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Divider(),

                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(Icons.star_border, color: Colors.white),
                        ),
                        title: Text("Starred"),
                        trailing: Text(
                          "2",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
