import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  static const route = '/chat_room';

  ChatRoom({
    required this.userMap,
    required this.chatRoomId,
  }); //required this.user

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  Set<String> selectedMessages = {};

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: selectedMessages.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 28),
              onPressed: () {
                setState(() {
                  selectedMessages.clear();
                });
              },
            )
          : IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        title: selectedMessages.isNotEmpty
          ? Text('${selectedMessages.length} selected', style: const TextStyle(color: Colors.black, fontSize: 25))
          : Row (
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.userMap['profile_picture'] == null 
                  ? null 
                  : NetworkImage(widget.userMap['profile_picture']!),
                child: widget.userMap['profile_picture'] == null 
                  ? const Icon(Icons.person) 
                  : null,
              ),

              const SizedBox(width: 10),
              
              Text(widget.userMap['name'], style: const TextStyle(color: Color(0xFFFF5C01), fontSize: 25)),
            ],
          ),
        actions: selectedMessages.isNotEmpty
          ? [
              IconButton(
                icon: const Icon(Icons.delete, color: Color(0xFFFF5C01), size: 28),
                onPressed: deleteMessages,
              ),
            ]
          : [],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.3,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                  .collection('chatRoom')
                  .doc(widget.chatRoomId)
                  .collection('chats')
                  .orderBy('time', descending: false)
                  .snapshots(), 
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, Index) {
                        DocumentSnapshot document = snapshot.data!.docs[Index];
                        Map<String, dynamic> map = snapshot.data!.docs[Index].data() as Map<String, dynamic>;
                        return messages(size, map, document); //Text(snapshot.data!.docs[Index]['message']);
                      }
                    );
                  } else {
                    return Container();
                  }
                }),
              ),

              const SizedBox(height: 20),
            
              Container(
                height: size.height / 14,
                //width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    IconButton(
                      onPressed: sendImage, 
                      icon: const Icon(Icons.add, color: Color(0xFFFCB891), size: 38),
                    ),

                    Container(
                      height: size.height / 10,
                      width: size.width / 1.5,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xFFFCB891)),
                    ),
                  ),
                  IconButton(
                    onPressed: onSendMessage,
                    icon: const Icon(Icons.send,
                        color: Color(0xFFFCB891), size: 38),
                  ),
                ],
              ),
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  // Function to select a image
  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String messageText = const Icon(Icons.image).toString();
    String senderName = _auth.currentUser!.displayName ?? 'User';
    String receiverId = widget.userMap['uid'];
    String senderId = _auth.currentUser!.uid;
    String chatRoomId = widget.chatRoomId;

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });

      File imageFile = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('chat_images/$chatRoomId/$fileName')
          .putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> message = {
        'sendby': senderId,
        'message': imageUrl.isNotEmpty ? '🖼️ Image' : '',
        'imageUrl': imageUrl,
        'time': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(message);

      // Add the chatRoomId to the user's document when a message is sent
      addChatRoomId();

      // Increment unread messages count
      await _firestore.collection('chatRoom').doc(widget.chatRoomId).set({
        'unreadMessages': {widget.userMap['uid']: FieldValue.increment(1)}
      }, SetOptions(merge: true));

      setState(() {
        _isLoading = false;
      });

      sendNotification(receiverId, messageText, senderName, chatRoomId, senderId);
    }
  }

  // Function to send a message
  void onSendMessage() async {
    if(_message.text.isNotEmpty) {
      String messageText = _message.text;
      String senderName = _auth.currentUser!.displayName ?? 'User';
      String receiverId = widget.userMap['uid'];
      String senderId = _auth.currentUser!.uid;
      String chatRoomId = widget.chatRoomId;

      Map<String, dynamic> message = {
        'sendby' : _auth.currentUser!.uid,
        'message': messageText,
        'time' : FieldValue.serverTimestamp(),
        'unread' : 'true',
      };

      await _firestore
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(message);

      // Add the chatRoomId to the user's document when a message is sent
      addChatRoomId();

      // Ensure chatRoom document has the users field if it doesn't exist
      final chatRoomDoc =
          await _firestore.collection('chatRoom').doc(widget.chatRoomId).get();
      if (!chatRoomDoc.exists) {
        await _firestore.collection('chatRoom').doc(widget.chatRoomId).set({
          'users': [_auth.currentUser!.uid, widget.userMap['uid']],
          'unreadMessages': {
            widget.userMap['uid']: FieldValue.increment(
                1) // Increment unread messages for the other user
          },
        });
      } else {
        // Increment unread messages for the other user
        final otherUserId = chatRoomDoc['users']
            .firstWhere((userId) => userId != _auth.currentUser!.uid);
        await _firestore.collection('chatRoom').doc(widget.chatRoomId).set({
          'unreadMessages': {otherUserId: FieldValue.increment(1)},
        }, SetOptions(merge: true));
      }

      sendNotification(receiverId, messageText, senderName, chatRoomId, senderId);

      _message.clear();

    } else {
      print('Enter a message to send');
    }
  }

  Future<void> sendNotification(String receiverId, String message, String senderName, String chatRoomId, String senderId ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/profile/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'receiverId': receiverId,
        'message': message,
        'senderName': senderName,
        'senderId': senderId,
        'chatRoomId': chatRoomId,
      }),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }

  void addChatRoomId() async {
    String uid = _auth.currentUser!.uid;
    String otherUid = widget.userMap['uid'];
    String chatRoomId = widget.chatRoomId;

    DocumentReference userDoc1 = _firestore.collection('users').doc(uid);
    DocumentReference userDoc2 = _firestore.collection('users').doc(otherUid);

    //Update chatRooms for the current user
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc1);
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        // Check if the chatRooms field exists and is a list
        if (data.containsKey('chatRooms') && data['chatRooms'] is List) {
          List<dynamic> chatRooms = data['chatRooms'] as List<dynamic>? ?? [];
          // Remove existing entry if it exists
          chatRooms.removeWhere((room) => room['chatRoomId'] == chatRoomId);
          // Add new entry at the beginning
          chatRooms.insert(0, {'otherUid': otherUid, 'chatRoomId': chatRoomId});

          transaction.update(userDoc1, {'chatRooms': chatRooms});
        } else {
          // If chatRooms doesn't exist, create it
          transaction.update(userDoc1, {
            'chatRooms': [{'otherUid': otherUid, 'chatRoomId': chatRoomId}]
          });
        }
      } else {
        // If the document doesn't exist or has no data, create it with the chatRooms field
        transaction.set(userDoc1, {
          'chatRooms': [
            {'otherUid': otherUid, 'chatRoomId': chatRoomId}
          ]
        });
      }
    });

    // Update chatRooms for the other user
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc2);
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Check if the chatRooms field exists and is a list
        if (data.containsKey('chatRooms') && data['chatRooms'] is List) {
          List<dynamic> chatRooms = data['chatRooms'] as List<dynamic>? ?? [];
          // Remove existing entry if it exists
          chatRooms.removeWhere((room) => room['chatRoomId'] == chatRoomId);
          // Add new entry at the beginning
          chatRooms.insert(0, {'otherUid': uid, 'chatRoomId': chatRoomId});

          transaction.update(userDoc2, {'chatRooms': chatRooms});
        } else {
          // If chatRooms doesn't exist, create it
          transaction.update(userDoc2, {
            'chatRooms': [{'otherUid': uid, 'chatRoomId': chatRoomId}]
          });
        }
      } else {
        // If the document doesn't exist or has no data, create it with the chatRooms field
        transaction.set(userDoc2, {
          'chatRooms': [
            {'otherUid': uid, 'chatRoomId': chatRoomId}
          ]
        });
      }
    });
  }

  // Widget to display messages
  Widget messages(Size size, Map<String,dynamic> map, DocumentSnapshot document) {
    bool isSelected = selectedMessages.contains(document.id);

    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          if (isSelected) {
            selectedMessages.remove(document.id);
          } else {
            selectedMessages.add(document.id);
          }
        });
      },
      onTap: () {
        if (selectedMessages.isNotEmpty) {
          setState(() {
            if (isSelected) {
              selectedMessages.remove(document.id);
            } else {
              selectedMessages.add(document.id);
            }
          });
        }
      },
      child: Container(
        //width: size.width,
        width: isSelected ? MediaQuery.of(context).size.width : size.width,
        alignment: map['sendby'] == _auth.currentUser!.uid 
          ? Alignment.centerRight 
          : Alignment.centerLeft,

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
            ? const Color(0xFFFF5C01)
            : map['sendby'] == _auth.currentUser!.uid 
              ? const Color(0xFFFCB891) 
              : const Color.fromARGB(255, 224, 224, 224),
            border: isSelected
              ? Border.all(color: const Color.fromARGB(255, 82, 54, 244), width: 2)
              : null, 
            borderRadius: BorderRadius.circular(10),
          ),
          child: map['message'] == const Icon(Icons.image).toString()
            ? Image.network(
                map['imageUrl'],
                height: size.height / 2.5,
              )
            : Text(
                map['message'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
        ),
      ),
    );
  }

  Future<void> deleteMessages() async {
    try {
      for (var messageId in selectedMessages) {
        final DocumentSnapshot messageSnapshot = await _firestore
            .collection('chatRoom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .doc(messageId)
            .get();

        if (messageSnapshot.exists) {
          final Map<String, dynamic> data = messageSnapshot.data() as Map<String, dynamic>;

          if (data['sendby'] == _auth.currentUser!.uid) {
            await _firestore
                .collection('chatRoom')
                .doc(widget.chatRoomId)
                .collection('chats')
                .doc(messageId)
                .delete();
          } else {
            return showDialog (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Sorry,'),
                  content: const Text('You can only delete your own messages'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedMessages.clear();
                        });
                      },
                      child: const Text('OK', style: TextStyle(color: Color(0xFFFF5C01))),
                    ),
                  ],
                );
              },
            );
          }
        }
      }

      setState(() {
        selectedMessages.clear();
      });
    } catch (e) {
      print('Error deleting messages: $e');
    }
  }
}