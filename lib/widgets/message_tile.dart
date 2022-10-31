import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final int time;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.time})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 20,
        right: widget.sentByMe ? 20 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        //margin: widget.sentByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))
              : const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
          color: widget.sentByMe
              ? Theme.of(context).primaryColor
              : Colors.grey[600],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                textAlign: TextAlign.end,
                DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(widget.time)),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
            Text(
              widget.sender.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.message,
              style: const TextStyle(color: Colors.white, fontSize: 14,),
            ),
          ],
        ),
      ),
    );
  }
}
