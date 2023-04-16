import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String? uid;
  Database({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection("conversations");
  // saving the userdata
  Future saveUser(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profile_picture": "",
      "uid": uid,
      "friends": [],
      "pendingRequests": [],
      "requestsSent": []
    });
  }

  Future createNewConversation(List<String> users, String email) async {
    DocumentReference conversationDocumentReference =
        await conversationCollection.add({
      "users": users,
      "reciepientAvatar": "",
      "conversationId": "",
    });
    await conversationDocumentReference.update({
      "conversationId": conversationDocumentReference.id,
    });
  }

  Future updateAvatar(String url) async {
    return await userCollection.doc(uid).update({"profile_picture": url});
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  Future isUserJoined(String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future isFriended(String strangerUid) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> friends = await documentSnapshot['friends'];
    if (friends.contains(strangerUid)) {
      return true;
    } else {
      return false;
    }
  }

  //joining and leaving a group
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    // if user has the groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  //send a message to a group
  sendGroupMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  //send a message to a user
  sendUserMessage(
      String conversationId, Map<String, dynamic> chatMessageData) async {
    conversationCollection
        .doc(conversationId)
        .collection("messages")
        .add(chatMessageData);
    conversationCollection.doc(conversationId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // getting user data
  getUserEmail(String email) async {
    return userCollection.where("email", isEqualTo: email).get();
  }

  // get user groups and friends
  getUserMetaData() async {
    return userCollection.doc(uid).snapshots();
  }

  //get recent message
  Future getGroupRecentMessage(String groupId) async {
    DocumentSnapshot doc = await groupCollection.doc(groupId).get();
    return doc["recentMessage"];
  }

  //get the avatar of the group based on the group id
  Future getGroupAvatar(String groupId) async {
    DocumentSnapshot doc = await groupCollection.doc(groupId).get();
    return doc["groupIcon"];
  }

  //get the avatar of a friend based on the user id
  Future getFriendAvatar(String userId) async {
    DocumentSnapshot doc = await userCollection.doc(userId).get();
    return doc["profile_picture"];
  }

  Future getFriendUsername(String userId) async {
    DocumentSnapshot doc = await userCollection.doc(userId).get();
    return doc["fullName"];
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentSnapshot documentSnapshot =
        await groupCollection.doc(groupId).get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search for groups
  searchGroups(String groupName) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  //search for users
  searchUsers(String userName) async {
    return userCollection.where("fullName", isEqualTo: userName).get();
  }

  addFriend() {}
}
