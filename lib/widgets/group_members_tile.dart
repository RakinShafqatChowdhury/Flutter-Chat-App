import 'package:flutter/material.dart';

class GroupMembersTile extends StatefulWidget {
  final String memberName;
  final String groupId;
  final String groupName;

  const GroupMembersTile(
      {Key? key,
      required this.memberName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupMembersTile> createState() => _GroupMembersTileState();
}

class _GroupMembersTileState extends State<GroupMembersTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Card(
        elevation: 2,
        borderOnForeground: true,
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.memberName.split("_").last.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.memberName.split("_").last,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(widget.groupName),
        ),
      ),
    );
  }
}
