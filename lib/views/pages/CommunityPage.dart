import 'package:flutter/material.dart';
import 'package:fv2/models/Filter.dart';
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
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // wait for widgets to be built then fetch
      try {
        PostProvider postProvider = Provider.of<PostProvider>(
          context,
          listen: false,
        );

        // Initialize the provider with correct filter settings
        postProvider.initialHomePage();

        // Then fetch the posts
        postProvider.getTodayPostsDataTesting();
      } on Exception catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching posts: $e')));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("🔁 CommunityPage rebuilt");
    PostProvider postProvider = Provider.of<PostProvider>(
      context,
      listen: false,
    ); // get post // reset filter and selected post
    return EasyRefresh(
      onRefresh: postProvider.getTodayPostsDataTesting,
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
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {
                          // postProvider.applySearch(searchController.text);
                          if (searchController.text != "") {
                            postProvider.currentFilter?.searhInput =
                                searchController.text;
                            postProvider.getTodayPostsDataTesting();
                          }
                        },
                        icon: Icon(Icons.search, color: Colors.blueGrey),
                      ),
                      title: TextField(
                        onChanged: (value) => {
                          if (value.isEmpty) {postProvider.applySearch("")},
                        },
                        onSubmitted: (value) => postProvider.applySearch(value),
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Community',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Filter? filter = await showFilterDialog(context: context);
                      if (filter != null) {
                        postProvider.currentFilter?.setDate(filter.date!);
                        postProvider.currentFilter?.setSortBy(filter.sortBy!);
                        // selectedFilter = postProvider.currentFilter;
                        postProvider.getTodayPostsDataTesting();
                      }
                    },
                    icon: Icon(Icons.tune, color: Colors.blueGrey),
                  ),
                ],
              ),
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
            Text(
              "Community Feed",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            PostListWidget(),
          ],
        ),
      ),
    );
  }
}
