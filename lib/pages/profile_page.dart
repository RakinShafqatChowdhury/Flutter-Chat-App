import 'package:chat_app/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../widgets/widgets_helper.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName = "";
  String email = "";

  ProfilePage({
    Key? key,
    required this.userName,
    required this.email,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              title: const Text("Groups"),
              leading: const Icon(Icons.group_rounded),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            ),
            ListTile(
              onTap: () {},
              title: const Text("Profile"),
              leading: const Icon(Icons.account_circle),
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel_rounded),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () {
                              AuthService().signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.done_rounded),
                            color: Colors.green,
                          ),
                        ],
                      );
                    });
              },
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app_rounded),
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              const Icon(
                Icons.account_circle,
                color: Colors.grey,
                size: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Full Name",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    widget.email,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
