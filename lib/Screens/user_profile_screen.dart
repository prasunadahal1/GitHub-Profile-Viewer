import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            pinned: true,
            leading:  BackButton(color: Colors.black),
            actions:  [
              Icon(Icons.share_outlined, color: Colors.blue),
              SizedBox(width: 10),
              Icon(Icons.more_vert, color: Colors.blue),
              SizedBox(width: 10),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          "https://img.magnific.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3467.jpg?semt=ais_hybrid&w=740&q=80",
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            "Prasuna Dahal",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "prasunadahal1",
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
                    children:  [
                      Icon(
                        Icons.person_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "1 ",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "follower",
                        style: TextStyle(fontSize: 18,color: Colors.grey.shade700),
                      ),
                      Text(
                        " • ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "2 ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "following",
                        style: TextStyle(fontSize: 18,color: Colors.grey.shade700),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  Divider(),

                  ListTile(
                    onTap: (){},
                    leading:  Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.book_outlined,color: Colors.white,)),
                    title:  Text("Repositories",style: TextStyle(),),
                    trailing:  Text(
                      "5",
                      style: TextStyle(fontSize: 16,color: Colors.grey.shade700),
                    ),
                  ),
                   Divider(),


                  ListTile(
                    leading:  Container(
                        padding:  EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.apartment_outlined,color: Colors.white,)),
                    title:  Text("Organizations"),
                    trailing:  Text(
                      "0",
                      style: TextStyle(fontSize: 16,color: Colors.grey.shade700),
                    ),
                  ),
                   Divider(),


                  ListTile(
                    leading:  Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.star_border,color: Colors.white,)),
                    title:  Text("Starred"),
                    trailing:  Text(
                      "2",
                      style: TextStyle(fontSize: 16,color: Colors.grey.shade700),
                    ),
                  ),
                   Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
