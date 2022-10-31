import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollectionRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollectionRef =
      FirebaseFirestore.instance.collection("groups");

  Future savingUserData(String fullName, String email) async {
    return await userCollectionRef.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  Future gettingUserData(String email) async {
    try {
      QuerySnapshot snapshot =
          await userCollectionRef.where("email", isEqualTo: email).get();
      return snapshot;
    } catch (e) {
      return null;
    }
  }

  Future getUserGroups() async {
    return userCollectionRef.doc(uid).snapshots();
  }

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentRef = await groupCollectionRef.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime": "",
    });

    await groupDocumentRef.update({
      "members": FieldValue.arrayUnion(["{$uid}_$userName"]),
      "groupId": groupDocumentRef.id,
    });

    DocumentReference userDocumentRef = userCollectionRef.doc(uid);
    await userDocumentRef.update({
      "groups": FieldValue.arrayUnion([
        "${groupDocumentRef.id}_$groupName",
      ])
    });
  }

  getChat(String groupId) async {
    return groupCollectionRef
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference documentReference = groupCollectionRef.doc(groupId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(String groupId) async {
    return groupCollectionRef.doc(groupId).snapshots();
  }

  searchGroupByName(String groupName) async {
    return groupCollectionRef.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(
    String groupName,
    String groupId,
    String userName,
  ) async {
    DocumentReference documentReference = userCollectionRef.doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoinOrRemove(
    String groupId,
    String groupName,
    String userName,
  ) async {
    DocumentReference userDocumentReference = userCollectionRef.doc(uid);
    DocumentReference groupsDocumentReference = groupCollectionRef.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupsDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupsDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }
  
  sendMessage(String groupId, Map<String, dynamic> chatMessageData){
    groupCollectionRef.doc(groupId).collection('messages').add(chatMessageData);
    groupCollectionRef.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'],
    });
  }
}
