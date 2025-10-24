import 'package:flutter/material.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/views/pages/components/post/PostListWidget.dart';
import 'package:fv2/views/pages/components/search/showFilterDialog.dart';
import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final onPressed = () {
    print("Camera Clicked");
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   PostProvider postProvider = Provider.of<PostProvider>(context,listen:false); // get post
    return EasyRefresh(
                      onRefresh: postProvider.getTodayPostsData,
                      onLoad: postProvider.hasMore ? postProvider.LoadMoreTodayPostsData : null,
                      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.search, color: Colors.blueGrey),
                  title: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Community',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            IconButton(onPressed: ()=>{
                showFilterDialog(context:context)
            }, icon: Icon(Icons.tune, color: Colors.blueGrey))
            ],),
            ),
        
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(15.0),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8.0),
      
          //   ),
          //   child: Row(children: [
          //     Icon( Icons.people, color: Colors.blue, size: 30),
          //     SizedBox(width: 10),
          //     Text("User Management"),
          //     Spacer(),
          //     IconButton(onPressed: onPressed, icon: Icon(Icons.arrow_forward_ios))
          //   ],),
          // ),
          SizedBox(height: 20),
      
          PostListWidget(),
          ],
        ),
      ),
    );
  }
}
