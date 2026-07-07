import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
        body:Consumer<UserProfileProvider>(
          builder: (context,provider,_){
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  title: Text('Following'),
                ),
                SliverToBoxAdapter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal:0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.followingList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              provider.followingList[index]['avatar_url'] ?? "",
                            ),
                          ),
                          title: Text(
                            provider.followingList[index]['login'] ?? "no name",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
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

        )
    );

  }
}

