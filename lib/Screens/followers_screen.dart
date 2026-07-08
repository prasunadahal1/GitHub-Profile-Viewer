import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade300,
      body:Consumer<UserProfileProvider>(
        builder: (context,provider,_){
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                title: Text('Followers'),
              ),
              SliverToBoxAdapter(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal:0,),
                  physics:  NeverScrollableScrollPhysics(),
                  itemCount: provider.followersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            provider.followersList[index]['avatar_url'] ?? "",
                          ),
                        ),
                        title: Text(
                          provider.followersList[index]['login'] ?? "no name",
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
