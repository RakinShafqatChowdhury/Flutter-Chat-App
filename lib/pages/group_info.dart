import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/group_members_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets_helper.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String userName;

  const GroupInfo(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.adminName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    getGroupMembers();
    super.initState();
  }

  void getGroupMembers() {
    DatabaseService().getGroupMembers(widget.groupId).then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content: const Text("Are you sure you exit the group?"),
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
                              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoinOrRemove(widget.groupId, widget.groupName, widget.userName).whenComplete(() => {
                                nextScreenReplace(context, const HomePage())
                              });
                            },
                            icon: const Icon(Icons.done_rounded),
                            color: Colors.green,
                          ),
                        ],
                      );
                    });
              }, icon: const Icon(Icons.exit_to_app_rounded))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Text(
                      widget.adminName.split("_").last.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Group: ${widget.groupName.split("_").last}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Admin: ${widget.adminName.split("_").last}",
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null &&
                snapshot.data['members'].length > 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GroupMembersTile(
                      memberName: snapshot.data['members'][index],
                      groupId: widget.groupId,
                      groupName: widget.groupName);
                },
              );
            } else {
              return const Center(
                child: Text("No Members"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
