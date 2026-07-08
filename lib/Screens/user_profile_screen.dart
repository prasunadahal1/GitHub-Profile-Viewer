import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

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
                       Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Repositories",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                         SizedBox(
                           height:MediaQuery.of(context).size.height*0.2,
                           child: ListView.builder(
                             scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal:0,),
                            itemCount: p.repoList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, Routes.repoScreen);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  color: Colors.white,
                                 child: Column(
                                   crossAxisAlignment: .start,
                                   children: [
                                     Row(
                                       children: [
                                         CircleAvatar(backgroundImage: NetworkImage( provider.image?? "",),
                                         ),
                                         SizedBox(width:7),
                                         Text(  provider.loginName ?? "",
                                           style: TextStyle(
                                             fontSize: 20,
                                             fontWeight: FontWeight.w400,
                                             color: Colors.grey.shade700,
                                           ),
                                         ),
                                       ],
                                     ),
                                       SizedBox(height:5),
                                       Text(p.repoList[index]['name'] ?? "no name of repo",
                                     style: TextStyle(
                                       fontWeight: FontWeight.w500,
                                      color: Colors.black,),
                                       ),
                                     SizedBox(height:5),
                                     Text(p.repoList[index]['description']??"no description",
                                       style: TextStyle(
                                         color: Colors.grey.shade700,
                                       ),
                                     ),
                                     Row(
                                       children: [
                                         Icon(Icons.star,color:Colors.amber.shade700,),
                                         SizedBox(width: 5),
                                         Text(p.repoList[index]['stargazers_count'].toString(),
                                           style: TextStyle(
                                             color: Colors.grey.shade700,
                                           ),
                                         ),
                                         SizedBox(width: 15),
                                         Container(
                                           width: 12,
                                           height: 12,
                                           decoration: BoxDecoration(
                                              color: Colors.blue,
                                             shape: BoxShape.circle,
                                           ),
                                         ),
                                         SizedBox(width:8),
                                         Text(p.repoList[index]['language']??"",
                                           style: TextStyle(
                                             color: Colors.grey.shade700,
                                           ),
                                         ),
                                       ],
                                     )
                                   ],
                                 ),

                                ),
                              );
                            },
                           ),
                         ),

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
// child: ListTile(
// leading: CircleAvatar(
// backgroundImage: NetworkImage('https://img.magnific.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg?semt=ais_hybrid&w=740&q=80'
// // provider.followersList[index]['avatar_url'] ?? "",
// ),
// ),
// title: Text('name',
// // provider.followersList[index]['login'] ?? "no name",
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.w500,
// color: Colors.black,
// ),
// ),
// subtitle:Text('hi',
// // repo["description"] ?? "No description",
// style: TextStyle(
// color: Colors.grey.shade700,
// ),
// ),
// ),