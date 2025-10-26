import 'package:flutter/material.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/views/pages/profile/ProfileEditPage.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  // final String name;
  // final String imageUrl;
  // final String description;

  const ProfilePage({
    super.key,
    // required this.name,
    // required this.imageUrl,
    // required this.description,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      if (!mounted) return;
      await Provider.of<Userprovider>(context, listen: false).setUserInfo();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<Userprovider>(context,listen: false).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Consumer<Userprovider>(
        builder: (context, userProvider, child) {
          User user = userProvider.getUser;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user.profile_Image != "" && user.profile_Image != null ?  CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(user.profile_Image!),
                ) : const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile1.jpeg'),
                ),
                const SizedBox(height: 16),
          
                // Name
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
              ),
          
                const SizedBox(height: 8),
          
                // Description
                Text(
                  user.description ?? 'no description',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                // Edit Profile Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditPage(
                          name: user.name,
                          imageUrl: user.profile_Image,
                          description: user.description,
                        ),
                      ),
                    );
          
                  },
                  child: const Text('Edit Profile'),
                  ),
                const SizedBox(height: 16),
                // Logout Button
                 ListTile(
                  style: ListTileStyle.drawer,
                  leading: const Icon(Icons.history),
                  title: const Text('Post History'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(context, '/postHistory');
                  },
                  
                ),
                ListTile(
                  style: ListTileStyle.drawer,
                  leading: const Icon(Icons.logout),
                  title: const Text('logout'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to post history page
                  },
                  
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
