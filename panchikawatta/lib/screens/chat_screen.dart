import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/chat_room.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isSearching = false;
  final FocusNode _searchfocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();  
  List<Map<String, dynamic>>? searchResults = []; //Empty list of maps, where each map has string keys and values of any type (dynamic).
  String? currentUserId;
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  String chatRoomId(String user1, String user2) {
    // Sort the two usernames to ensure a consistent order
    List<String> users = [user1, user2];
    users.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    // Concatenate the sorted usernames to create the chat room ID
    return users.join("");
  }


  @override
  void initState() {  //This function will call when the _buildSearchResults() widget is loaded
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;  //Get the current user's id
    _searchController.addListener(() {  //Listen to the changes in the search field. This will call every time the searchText change
      if (_searchController.text.isEmpty) {
        return ;  //If the search field is empty, do nothing.
      } else {
        onSearch(_searchController.text); //If the search field is not empty, call the onSearch function.
      }
    });
  }

  @override
  void dispose() {  //This function will call when the _buildSearchResults() widget is disposed/permanently removed from the screen
    _searchController.dispose();  //cleans up the resources used by _searchController.
    super.dispose();
  }

  void onSearch(String searchText) async {

    await _firestore
    .collection('users')
    .where('email', isGreaterThanOrEqualTo: searchText) 
    .where('email', isLessThan: searchText + 'z')   //The 'z' is added to the searchText to ensure that all possible strings that start with searchText are included in the results.
    .get()
    .then((value) {
      setState(() {
        searchResults = value.docs  //Access the docs property of the value object. This property is a list of all the documents returned by a Firestore query.
        .map((doc) => {'uid' : doc.id, ...doc.data(),}) //A method that transforms each item in the list. For each document (doc), it calls the data() method, which returns a Map<String, dynamic> representing the data in the document.
        // .where((user) => user['uid'] != currentUserId)  //A method that filters the list. It removes the current user from the search results.
        .toList();  //A method that converts the result of the map operation (which is an Iterable) back into a List.
      });
      print (searchResults);
    });

    setState(() {
      searchResults = searchResults!.where((user) => user['uid'] != currentUserId).toList();
    });
  }

  // void onSearch(String searchText) async {
  //   DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(currentUserId).get();
  //   List<String> chatRoomIds = List<String>.from((userSnapshot.data() as Map<String, dynamic>) ['chatRooms']);

  //   List<Map<String, dynamic>> searchResults = [];

  //   for (String chatRoomId in chatRoomIds) {
  //     DocumentSnapshot chatRoomSnapshot = await _firestore.collection('chatRoom').doc(chatRoomId).get();
  //     String otherUserId = (chatRoomSnapshot.data() as Map<String, dynamic>)['userIds'].firstWhere((userId) => userId != currentUserId);
  //     DocumentSnapshot otherUserSnapshot = await _firestore.collection('users').doc(otherUserId).get();

  //     if ((otherUserSnapshot.data() as Map<String, dynamic>)['email'].startsWith(searchText)) {
  //       searchResults.add({'uid' : otherUserSnapshot.id, ...(otherUserSnapshot.data() as Map<String, dynamic>)});
  //     }
  //   }

  //   setState(() {
  //     this.searchResults = searchResults;
  //   });

  //   print(searchResults);
  // }


  Widget _buildSearchResults() {
    final results = searchResults;

    if (results == null || results.isEmpty) {
      return const Center(
        child: Text('No results found', style: TextStyle(fontSize: 20)),
      );
    }

    

    return ListView.builder(  //A scrollable list of widgets that are created on demand.
      itemCount: searchResults?.length ?? 0, //searchResults!.isEmpty ? 0 : searchResults!.length,
      itemBuilder: (context, index) {   //The itemBuilder function is called for each item in the list.
        
        if (index < results.length) {
          return Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,  // left
                  0,                                        // top
                  MediaQuery.of(context).size.width * 0.05,  // right
                  0,                                        // bottom
                ),
              child: Container( 
                height: 75,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFFF5C01))),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: results[index]['profile_picture'] == null 
                      ? null 
                      : NetworkImage(results[index]['profile_picture']),
                    child: results[index]['profile_picture'] == null 
                      ? const Icon(Icons.person) 
                      : null,
                  ),
                  onTap: () { 
                    String roomId = chatRoomId(
                      _auth.currentUser!.uid ,
                      searchResults![index]['uid'],
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          chatRoomId: roomId,
                          userMap: searchResults![index],
                          user : searchResults![index]['uid']
                        )
                      )
                    );
                    
                  },
                  title: Text(results[index]['name'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  subtitle: Text(results[index]['email'], style: const TextStyle(fontSize: 15)),
                ),
              ),
            );
          // }
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? Container() : IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
          onPressed: () {
            // Navigate to the previous page
            Navigator.pop(context);
          },
        ),
        title: _isSearching ?
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: InputFields(
                  hintText: 'Search..', 
                  width1: 0.8,
                  focusNode: _searchfocusNode,
                  controller: _searchController,
                ),
              ),
            ],
          ) :
          const Text('Chats', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
        actions: [
          IconButton(
            icon:  Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black, size: 28),
            onPressed: () {
              // Display the input field for search
              setState(() {
                if (_isSearching) {
                  _searchfocusNode.unfocus();
                } 
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),

      body: _isSearching ? _buildSearchResults() 
        // : Container(
        //   child: const Center(
        //     child: Text('Search for a user to chat with', style: TextStyle(fontSize: 20)),
        //   ),
        : StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).snapshots(), //get the document of the current user
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final chatrooms = snapshot.data?.data() ;
              final chatRooms = chatrooms is Map<String, dynamic> ? chatrooms['chatRooms'] as List<dynamic>? ?? [] : [] ; //(snapshot.data!.data() as Map<String, dynamic>)['chatRooms'] as List<dynamic>;
              //final chatRooms = (snapshot.data!.data() as Map<String, dynamic>)['chatRooms'] as List<dynamic>;
              // final chatRoomIds = chatRooms.map((chatRoom) => chatRoom as String).toList();
              // return _buildChatRoomList(chatRoomIds);

              if (chatRooms.isEmpty) {
                return const Center(
                  child: Text('You have not chat with anyone', style: TextStyle(fontSize: 20)),
                );
              }

              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final item = chatRooms[index]; //as Map<String, dynamic>;
                  Map<String, dynamic>? chatRoomMap ;
                  String? chatRoomId ;

                  if (item is Map<String, dynamic>) {
                    chatRoomMap = item;
                    final id = chatRoomMap['chatRoomId'] ;//as String;

                    if (id is String) {
                      chatRoomId = id;
                    } else {
                      print('chatRoomId is not a String');
                    }
                  } else {
                    print('Item at index $index is not a Map<String, dynamic>');
                  }

                  if (chatRoomId == null) {
                    return const SizedBox.shrink();
                  }

                  // final chatRoomId = chatRoomMap['chatRoomId'] as String;
                  final otherUserId = chatRoomMap?['otherUid'] as String? ?? 'defaultUserId';

                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                      .collection('chatRoom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy('time', descending: true)
                      .snapshots(),
                    builder: (context, chatSnapshot) {
                      if (chatSnapshot.hasData && chatSnapshot.data != null) {

                        final chatDocs = chatSnapshot.data!.docs;

                        if (chatDocs.isEmpty) {
                          print('No chat messages found');
                          return const SizedBox.shrink();
                        }

                        final lastMessage = chatDocs.first;

                        return FutureBuilder<DocumentSnapshot>(
                          future: _firestore.collection('users').doc(otherUserId).get(), 
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.done && userSnapshot.hasData) {

                              final data = userSnapshot.data?.data() ;
                              final userDisplayName =  data is Map<String, dynamic> ? data['name'] as String? ?? 'defaultName' : 'defaultname' ; //(userSnapshot.data?.data() as Map<String, dynamic>)['name'] as String;
                              // final pic = userSnapshot.data?.data();
                              final userDisplayPicture = data is Map<String, dynamic> ? data['profile_picture'] as String? ?? '' : '' ; //(userSnapshot.data?.data() as Map<String, dynamic>)['profile_picture'] as String? ?? '';
                              //final userDisplayPicture = (userSnapshot.data!.data() as Map<String, dynamic>)['profile_picture'] as String? ?? '';
                              return Padding (
                                padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.05,  // left
                                  0,                                        // top
                                  MediaQuery.of(context).size.width * 0.05,  // right
                                  0,                                        // bottom
                                ),
                                child: Container( 
                                  height: 75,
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFFF5C01))),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: userDisplayPicture.isEmpty 
                                        ? null 
                                        : NetworkImage(userDisplayPicture),
                                      child: userDisplayPicture.isEmpty  
                                        ? const Icon(Icons.person) 
                                        : null,
                                    ),
                                    onTap: () { 
                                      // String roomId = this.chatRoomId(
                                      //   _auth.currentUser!.uid ,
                                      //   searchResults![index]['uid'],
                                      // );

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ChatRoom(
                                            chatRoomId: chatRoomId as String, //roomId
                                            userMap: {'uid': otherUserId, 'name': userDisplayName, 'profile_picture': userDisplayPicture},  //searchResults![index],
                                            user: otherUserId,
                                          )
                                        )
                                      );
                                      
                                    },
                                
                                    title: Text(userDisplayName), 
                                    subtitle: Text(lastMessage['message']),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text('You have not chat with anyone', style: TextStyle(fontSize: 20)),
              );
            }
          },
        ), 

    );
  }
}