import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Routes/app_routes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    late UserProfileProvider p = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    late DashboardProvider provider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );
    p.getRepo(provider.searchController.value.text);
    // p.getLanguages(provider.loginName!, p.name!);
    super.initState();
  }

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
                centerTitle: false,
                leading:IconButton(onPressed: (){
                  Navigator.pushNamed(context, Routes.dashboardScreen);
                }, icon: Icon(Icons.arrow_back_ios)),
                title: Text(
                  'Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  Icon(Icons.share_outlined, color: Colors.blue),
                  SizedBox(width: 10),
                  Icon(Icons.more_vert, color: Colors.blue),
                  SizedBox(width: 10),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(provider.image ?? ""),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  provider.getUrl();
                                },
                                child: Text(
                                  provider.name ?? "no name",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 18,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4),
                          Text(
                            provider.followers ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              p.getFollowers(provider.value!);
                              Navigator.pushNamed(
                                context,
                                Routes.followersScreen,
                              );
                            },
                            child: Text(
                              "followers",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Text(" • ", style: TextStyle(fontSize: 16)),
                          Text(
                            provider.following ?? "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              p.getFollowing(provider.value!);
                              Navigator.pushNamed(
                                context,
                                Routes.followingScreen,
                              );
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
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(color: Colors.white, child: Divider()),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(
                    "Repositories",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Material(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          itemCount: p.repoList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                p.setRepoData(
                                  p.repoList[index]['name'] ?? "No name",
                                  p.repoList[index]['description'] ??
                                      "No description",
                                  p.repoList[index]['stargazers_count']
                                      .toString(),
                                  p.repoList[index]['forks_count'].toString(),
                                  p.repoList[index]['open_issues'].toString(),
                                  p.repoList[index]['watchers_count']
                                      .toString(),
                                  p.repoList[index]['html_url'],
                                );
                                Navigator.pushNamed(
                                  context,
                                  Routes.repoScreen,
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            provider.image ?? "",
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          provider.loginName ?? "",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      p.repoList[index]['name'] ??
                                          "no name of repo",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      p.repoList[index]['description'] ??
                                          "no description",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber.shade700,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          p.repoList[index]['stargazers_count']
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: p.getLanguageColor(
                                              p.repoList[index]['language'],
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          p.repoList[index]['language'] ??
                                              "Null",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      ListTile(
                        onTap: () {},
                        leading: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.book_outlined,
                            color: Colors.white,
                          ),
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
                          child: Icon(
                            Icons.star_border,
                            color: Colors.white,
                          ),
                        ),
                        title: Text("Starred"),
                        trailing: Text(
                          p.totalStarCount,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
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
