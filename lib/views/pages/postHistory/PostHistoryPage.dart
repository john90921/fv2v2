
import 'package:flutter/material.dart';
import 'package:fv2/models/Filter.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/views/pages/components/post/PostListWidget.dart';
import 'package:fv2/views/pages/components/search/showFilterDialog.dart';
import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';
class PostHistoryPage extends StatefulWidget {
  const PostHistoryPage({super.key});

  @override
  State<PostHistoryPage> createState() => _PostHistoryPageState();
}

class _PostHistoryPageState extends State<PostHistoryPage> {
 final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
 
  WidgetsBinding.instance.addPostFrameCallback((_) {
      // wait for widgets to be built then fetch
      try {
 final user_id = Provider.of<Userprovider>(context, listen: false).getUser.id;
 Provider.of<PostProvider>(context, listen: false).setCurrentFilter(Filter.owner(
    userId: user_id,
    date: "year",
    sortBy: "latest",
    searhInput: null,
  ));
  Provider.of<PostProvider>(context, listen: false).getTodayPostsDataTesting();
  
} on Exception catch (e) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Error fetching posts: $e')));
}
          
  });
  super.initState();

  }
  

  @override
  Widget build(BuildContext context) {
    print("🔁 CommunityPage rebuilt");
   PostProvider postProvider = Provider.of<PostProvider>(context,listen:false); // get post // reset filter and selected post
    return Scaffold(
      appBar: AppBar(
        title: Text("My Post History"), 
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        
        ),
      
      ),
      body: SafeArea(
        child: EasyRefresh(
                          onRefresh: postProvider.getTodayPostsDataTesting,
                          onLoad: postProvider.hasMore ? postProvider.LoadMoreTodayPostsData : null,
                          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
              
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
        ),
      ),
    );
  }
}
