import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github_profile_viewer/Providers/dashboard_provider.dart';
import 'package:github_profile_viewer/Providers/user_profile_provider.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Routes/app_routes.dart';

class RepoScreen extends StatefulWidget {
  const RepoScreen({super.key});

  @override
  State<RepoScreen> createState() => _RepoScreenState();
}

class _RepoScreenState extends State<RepoScreen> {
  late UserProfileProvider p = Provider.of<UserProfileProvider>(
    context,
    listen: false,
  );
  late DashboardProvider provider = Provider.of<DashboardProvider>(
    context,
    listen: false,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await p.getContributors(provider.loginName!, p.name!);
      await p.getLanguages(provider.loginName!, p.name!);
      print("LANGUAGES: ${p.languages}"); });
    // print("NAME: ${p.name}");
    // print("LOGIN: ${provider.loginName}");
    // p.getContributors(provider.loginName!, p.name!);
    // p.getLanguages(provider.loginName!, p.name!);
    // print("LANGUAGES: ${p.languages}");
    // // Use the GitHub login from the API, not search field text (can be empty/wrong).
    // final owner = provider.loginName ?? provider.value ?? '';
    // final repoName = p.name ?? '';
    // if (owner.isNotEmpty && repoName.isNotEmpty) {
    //   p.getContributors(owner, repoName);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProfileProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            pinned: true,
            leading: IconButton(onPressed: (){
              p.clearLanguage();
              Navigator.pushNamed(context, Routes.userProfileScreen);
            }, icon:Icon(Icons.arrow_back_ios)),
            title: Text('Repository',style: TextStyle(fontWeight: FontWeight.bold),),
            actions: [
              Icon(Icons.add_circle_outline, color: Colors.blue),
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
                        radius:15,
                        backgroundImage: NetworkImage(
                          provider.image?? "",
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        provider.loginName ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(height:15),
                  Text(p.name??"",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,),
                  ),
                  SizedBox(height: 15),
                  Text( p.description ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(Icons.star_border,color: Colors.grey.shade700,),
                      SizedBox(width: 5),
                      Text(p.star??"",
                        // p.repoList[index]['stargazers_count'].toString(),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 3),
                      Text('star',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width:18),
                      FaIcon(FontAwesomeIcons.codeFork,color:Colors.grey.shade500,size: 20,),
                      SizedBox(width: 5),
                      Text(p.forks??"",
                        // p.repoList[index]['language']??"",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text('forks',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:10),
                  Divider(),
                  ListTile(
                    onTap: () {},
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FaIcon(FontAwesomeIcons.circleDot, color: Colors.white,),
                    ),
                    title: Text("Issues", style: TextStyle()),
                    trailing: Text(p.issues??"0",
                      // provider.user['public_repos'].toString(),
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
                      child: Icon(Icons.people_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("Contributors"),
                    trailing: Text(
                      p.contributorsList.length.toString(),
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
                      child: FaIcon(FontAwesomeIcons.eye, color: Colors.white),
                    ),
                    title: Text("Watchers"),
                    trailing: Text(
                      p.watcher??"0",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Divider(),
                 ExpansionTile(
                   shape: Border(),
                     leading: Container(
                       padding: EdgeInsets.all(8),
                       decoration: BoxDecoration(
                         color: Colors.amber.shade700,
                         borderRadius: BorderRadius.circular(6),
                       ),
                       // child: FaIcon(FontAwesomeIcons.language, color: Colors.white),
                       child:(Icon(Icons.language,color: Colors.white)),
                     ),
                     title: Text("Languages"),
                   children: [
                     // FIX: MultiSegmentLinearIndicator crashes (RangeError) when
                     // segments is empty — e.g. before getLanguages finishes or
                     // after clearLanguage(). Only build it when data exists.
                     if (p.languages.isEmpty)
                       Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Center(child: CircularProgressIndicator()),
                       )
                     else ...[
                       ClipRRect(
                         borderRadius: BorderRadius.circular(10),
                         child: MultiSegmentLinearIndicator(
                           // FIX: key forces a fresh animation state when segment
                           // count changes (avoids animateFromLastPercent RangeError)
                           key: ValueKey(p.languages.keys.join(',')),
                           width: MediaQuery.of(context).size.width - 68,
                           lineHeight: 14.0,
                           animation: true,
                           animateFromLastPercent: true,
                           animationDuration: 1000,
                           curve: Curves.easeInOut,
                           barRadius: Radius.circular(10),
                           segments: p.buildSegments(p.languages),
                         ),
                       ),
                       SizedBox(height: 16,),
                       Wrap(
                         spacing: 16,
                         runSpacing: 8,
                         children: p.languages.entries.map((e) {
                           // FIX: guard totalLanguageBytes == 0 to avoid / 0
                           final percentText = p.totalLanguageBytes == 0
                               ? '0.0'
                               : ((e.value as num).toInt() /
                                       p.totalLanguageBytes *
                                       100)
                                   .toStringAsFixed(1);
                           return Container(
                             padding:
                             EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20),
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Container(
                                   width: 10,
                                   height: 10,
                                   decoration: BoxDecoration(
                                     color: p.getLanguageColor(e.key),
                                     shape: BoxShape.circle,
                                   ),
                                 ),
                                 SizedBox(width: 6),
                                 Text(
                                   e.key,
                                   style:  TextStyle(
                                     fontSize: 13,
                                     fontWeight: FontWeight.w500,
                                     color: Colors.black87,
                                   ),
                                 ),
                                 SizedBox(width: 4),
                                 Text(
                                   '$percentText%',
                                   style: TextStyle(
                                     fontSize: 13,
                                     fontWeight: FontWeight.w400,
                                     color: Colors.grey.shade600,
                                   ),
                                 ),
                               ],
                             ),
                           );
                         }).toList(),
                       ),
                     ],
                   ],
                 ),
                  Divider(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
