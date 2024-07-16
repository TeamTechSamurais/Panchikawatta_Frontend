import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/chat_room.dart';
import 'package:badges/badges.dart' as badges;

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isSearching = false;
  bool _isSelecting = false;
  final FocusNode _searchfocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>>? searchResults = []; //Empty list of maps, where each map has string keys and values of any type (dynamic).
  String? currentUserId;
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> selectedChatRooms = [];  

  String chatRoomId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return users.join("");
  }

  @override
  void initState() {
    //This function will call when the _buildSearchResults() widget is loaded
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;  //Get the current user's id

    _searchController.addListener(() {  //Listen to the changes in the search field. This will call every time the searchText change

      if (_searchController.text.isEmpty) {
        return; //If the search field is empty, do nothing.
      } else {
        onSearch(_searchController
            .text); //If the search field is not empty, call the onSearch function.
      }
    });
  }

  @override
  void dispose() {
    //This function will call when the _buildSearchResults() widget is disposed/permanently removed from the screen
    _searchController
        .dispose(); //cleans up the resources used by _searchController.
    super.dispose();
  }

  // void onSearch(String searchText) async {
  //   await _firestore
  //   .collection('users')
  //   .where('email', isGreaterThanOrEqualTo: searchText) 
  //   .where('email', isLessThan: searchText + 'z')   //The 'z' is added to the searchText to ensure that all possible strings that start with searchText are included in the results.
  //   .get()
  //   .then((value) {
  //     setState(() {
  //       searchResults = value.docs  //Access the docs property of the value object. This property is a list of all the documents returned by a Firestore query.
  //       .map((doc) => {'uid' : doc.id, ...doc.data(),}) //A method that transforms each item in the list. For each document (doc), it calls the data() method, which returns a Map<String, dynamic> representing the data in the document.
  //       // .where((user) => user['uid'] != currentUserId)  //A method that filters the list. It removes the current user from the search results.
  //       .toList();  //A method that converts the result of the map operation (which is an Iterable) back into a List.
  //     });
  //     print (searchResults);
  //   });

  //   setState(() {
  //     searchResults = searchResults!.where((user) => user['uid'] != currentUserId).toList();
  //   });
  // }

  void onSearch(String searchText) async {
    // Retrieve the current user's chat rooms
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(currentUserId).get();
    List<Map<String, dynamic>> chatRooms = List<Map<String, dynamic>>.from((userSnapshot.data() as Map<String, dynamic>)['chatRooms']);

    List<Map<String, dynamic>> searchResults = [];

    for (var chatRoom in chatRooms) {
      // String chatRoomId = chatRoom['chatRoomId'];
      String otherUserId = chatRoom['otherUid'];

      // Retrieve the other user's document from the users collection
      DocumentSnapshot otherUserSnapshot = await _firestore.collection('users').doc(otherUserId).get();
      String displayName = (otherUserSnapshot.data() as Map<String, dynamic>)['name'];

      // Check if the display name starts with the search text
      if (displayName.toLowerCase().startsWith(searchText.toLowerCase())) {
        searchResults.add({
          'uid': otherUserSnapshot.id,
          ...otherUserSnapshot.data() as Map<String, dynamic>
        });
      }
    }

    setState(() {
      this.searchResults = searchResults;
    });

    print(searchResults);
  }

  Future<void> _deleteSelectedChats() async {
    for (String chatRoomId in selectedChatRooms) {
      // Delete chat room from Firestore
      // await _firestore.collection('chatRoom').doc(chatRoomId).delete();

      // Remove chat room from current user's chatRooms field
      DocumentSnapshot currentUserSnapshot = await _firestore.collection('users').doc(currentUserId).get();
      Map<String, dynamic> currentUserData = currentUserSnapshot.data() as Map<String, dynamic>;
      List<dynamic> currentUserChatRooms = currentUserData['chatRooms'];
      var chatRoomToRemove = currentUserChatRooms.firstWhere((chatRoom) => chatRoom['chatRoomId'] == chatRoomId);

      await _firestore.collection('users').doc(currentUserId).update({
        'chatRooms': FieldValue.arrayRemove([chatRoomToRemove]),
      });

      // Get the other userId from the chatRoom object
      // String otherUserId = chatRoomToRemove['otherUid'];

      // // Remove chat room from other user's chatRooms field
      // DocumentSnapshot otherUserSnapshot = await _firestore.collection('users').doc(otherUserId).get();
      // Map<String, dynamic> otherUserData = otherUserSnapshot.data() as Map<String, dynamic>;
      // List<dynamic> otherUserChatRooms = otherUserData['chatRooms'];
      // var otherChatRoomToRemove = otherUserChatRooms.firstWhere((chatRoom) => chatRoom['chatRoomId'] == chatRoomId);

      // await _firestore.collection('users').doc(otherUserId).update({
      //   'chatRooms': FieldValue.arrayRemove([otherChatRoomToRemove]),
      // });

      // // Delete images from Firebase Storage
      // ListResult result = await FirebaseStorage.instance.ref('chat_images/$chatRoomId').listAll();
      // for (Reference fileRef in result.items) {
      //   await fileRef.delete();
      // }
    }

    setState(() {
      _isSelecting = false;
      selectedChatRooms.clear();
    });
  }

  Widget _buildSearchResults() {
    final results = searchResults;

    if (results == null || results.isEmpty) {
      return const Center(
        child: Text('No results found', style: TextStyle(fontSize: 20)),
      );
    }

    return ListView.builder(  //A scrollable list of widgets that are created on demand.
      itemCount: searchResults?.length ?? 0, 
      itemBuilder: (context, index) {   //The itemBuilder function is called for each item in the list.
        if (index < results.length) {
          final String roomId = chatRoomId(_auth.currentUser!.uid, results[index]['uid']);

              return _buildChatTile(
                chatRoomId: roomId, 
                otherUserId: results[index]['uid'], 
                userDisplayName: results[index]['name'], 
                userDisplayPicture: results[index]['profile_picture'] ?? '', 
                unreadMessages: results[index]['unreadMessages'] ?? 0, 
                isSelected: selectedChatRooms.contains(roomId), 
                onSelect: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      selectedChatRooms.add(roomId);
                    } else {
                      selectedChatRooms.remove(roomId);
                    }
                  });
                }
              );
        } else {
          return Container();
        }
      },
    );
  }


  Widget _buildChatTile({
    required String chatRoomId,
    required String otherUserId,
    required String userDisplayName,
    required String userDisplayPicture,
    required int unreadMessages,
    required bool isSelected,
    required Function(bool) onSelect,
  }) {
    return FutureBuilder<String>(
      future: getLastMessage(chatRoomId),
      builder: (context, snapshot) {
        String lastMessage = snapshot.data ?? '';

        return GestureDetector(
          onTap: () {
            if (_isSelecting) {
              onSelect(!isSelected);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatRoom(
                    chatRoomId: chatRoomId,
                    userMap: {
                      'uid': otherUserId,
                      'name': userDisplayName,
                      'profile_picture': userDisplayPicture,
                    },
                  ),
                ),
              );

              // Reset unread messages count only if current user is the recipient
              if (_auth.currentUser!.uid == otherUserId) {
                _firestore.collection('chatRoom').doc(chatRoomId).update({
                  'unreadMessages': {
                    _auth.currentUser!.uid: 0,
                  },
                });
              }
            }
          },
          onDoubleTap: () {
            setState(() {
              _isSelecting = true;
              onSelect(!isSelected);
            });
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05, // left
              0, // top
              MediaQuery.of(context).size.width * 0.05, // right
              0, // bottom
            ),
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFFF5C01))),
                color: isSelected ? Color(0xFFFCB891) : Colors.transparent,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: userDisplayPicture.isEmpty
                      ? null
                      : NetworkImage(userDisplayPicture),
                  child: userDisplayPicture.isEmpty
                      ? Icon(Icons.person)
                      : null,
                ),
                title: Text(userDisplayName),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15),
                ),
                trailing: unreadMessages > 0
                    ? badges.Badge(
                        badgeContent: Text(
                          unreadMessages.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: Color(0xFFFF5C01),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> getLastMessage(String chatRoomId) async {
    final querySnapshot = await _firestore
      .collection('chatRoom')
      .doc(chatRoomId)
      .collection('chats')
      .orderBy('time', descending: true)
      .limit(1)
      .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['message'] ?? '';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !_isSelecting 
          ? _isSearching 
            ? Container() 
            : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 26),
            onPressed: () {
              setState(() {
                _isSelecting = false;
                selectedChatRooms.clear();
              });
            },
          ),
        title: !_isSelecting
          ? _isSearching 
            ? Flex(
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
            ) 
            : const Text('Chats', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28))
          : Text(
            '${selectedChatRooms.length} selected',
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.delete, color: Color(0xFFFF5C01)),
              onPressed: _deleteSelectedChats,
            )
          else
            IconButton(
              icon: Icon(_isSearching ? Icons.clear : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                  }
                });
              },
            ),
        ],
      ),

      // body: _isSearching 
      //   ? _buildSearchResults() 
      //   : StreamBuilder<DocumentSnapshot>(
      //     stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(), //get the document of the current user
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData && snapshot.data != null) {
      //         final chatrooms = snapshot.data?.data() ;
      //         final chatRooms = chatrooms is Map<String, dynamic> 
      //                             ? (chatrooms['chatRooms'] as List<dynamic>? ?? []).toList()  
      //                             : [] ; 

      //         if (chatRooms.isEmpty) {
      //           return const Center(
      //             child: Text('You have not chat with anyone', style: TextStyle(fontSize: 20)),
      //           );
      //         }

      //         return ListView.builder(
      //           itemCount: chatRooms.length,
      //           itemBuilder: (context, index) {
      //             final item = chatRooms[index]; 
      //             Map<String, dynamic>? chatRoomMap ;
      //             String? chatRoomId ;

      //             if (item is Map<String, dynamic>) {
      //               chatRoomMap = item;
      //               final id = chatRoomMap['chatRoomId'] ;

      //               if (id is String) {
      //                 chatRoomId = id;
      //               } else {
      //                 print('chatRoomId is not a String');
      //               }
      //             } else {
      //               print('Item at index $index is not a Map<String, dynamic>');
      //             }
      //             _isSearching = !_isSearching;
      //           });
      //       }
      //     },
      //   ),
      //   //   ],
      //   // ),
        body: _isSearching
            ? _buildSearchResults()
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .snapshots(), //get the document of the current user
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final chatrooms = snapshot.data?.data();
                    final chatRooms = chatrooms is Map<String, dynamic>
                        ? (chatrooms['chatRooms'] as List<dynamic>? ?? [])
                            .toList()
                        : []; //(snapshot.data!.data() as Map<String, dynamic>)['chatRooms'] as List<dynamic>;

                    if (chatRooms.isEmpty) {
                      return const Center(
                        child: Text('You have not chat with anyone',
                            style: TextStyle(fontSize: 20)),
                      );
                    }

                    return ListView.builder(
                      itemCount: chatRooms.length,
                      itemBuilder: (context, index) {
                        final item = chatRooms[index];
                        Map<String, dynamic>? chatRoomMap;
                        String? chatRoomId;

                        if (item is Map<String, dynamic>) {
                          chatRoomMap = item;
                          final id = chatRoomMap['chatRoomId'];

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

                        final otherUserId = chatRoomMap?['otherUid'] as String? ?? 'defaultUserId';

                        return StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('chatRoom')
                                .doc(chatRoomId)
                                .collection('chats')
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (context, chatSnapshot) {
                              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (chatSnapshot.hasError) {
                                return const Center(
                                  child: Text('An error occurred'),
                                );
                              }
                              if (!chatSnapshot.hasData ||
                                  chatSnapshot.data!.docs.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              // final chatDocs = chatSnapshot.data!.docs;

                              // final lastMessage = chatDocs.first;

                              return FutureBuilder<DocumentSnapshot>(
                                  future: _firestore
                                      .collection('users')
                                      .doc(otherUserId)
                                      .get(),
                                  builder: (context, userSnapshot) {
                                    // if (userSnapshot.connectionState == ConnectionState.waiting) { // && userSnapshot.hasData) {
                                    //   return const Center(
                                    //     child: CircularProgressIndicator(),
                                    //   );
                                    // }

                                    if (userSnapshot.hasError) {
                                      return const Center(
                                        child: Text('An error occurred'),
                                      );
                                    }

                                    final otherUserId = chatRoomMap?['otherUid'] as String? ?? 'defaultUserId';

                                    return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                      .collection('chatRoom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy('time', descending: true)
                      .snapshots(),
                    builder: (context, chatSnapshot) {
                      if (chatSnapshot.hasError) {
                        return const Center(
                          child: Text('An error occurred'),
                        );
                      }
                      if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      }

                        return FutureBuilder<DocumentSnapshot>(
                          future: _firestore.collection('users').doc(otherUserId).get(), 
                          builder: (context, userSnapshot) {

                            if (userSnapshot.hasError) {
                              return const Center(
                                child: Text('An error occurred'),
                              );
                            }

                            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                              return const SizedBox.shrink();
                            }

                              final data = userSnapshot.data?.data() ;
                              final userDisplayName =  data is Map<String, dynamic> ? data['name'] as String? ?? 'defaultName' : 'defaultname' ; 
                              final userDisplayPicture = data is Map<String, dynamic> ? data['profile_picture'] as String? ?? '' : '' ; 

                              return _buildChatTile(
                                chatRoomId: chatRoomId!,
                                otherUserId: otherUserId,
                                userDisplayName: userDisplayName,
                                userDisplayPicture: userDisplayPicture,
                                unreadMessages: (chatRoomMap?['unreadMessages'] ?? {})[_auth.currentUser!.uid] ?? 0,
                                isSelected: selectedChatRooms.contains(chatRoomId),
                                onSelect: (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedChatRooms.add(chatRoomId!);
                                    } else {
                                      selectedChatRooms.remove(chatRoomId);
                                    }
                                  });
                                },
                              );                              
                          }
                        );
                    }
                  );
                                  },
                              ); 
                            }
                        );
                      },
                    );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred'),
              );
            } else {
              return const Center(
                child: Text('You have not chat with anyone', style: TextStyle(fontSize: 20)),
              );
            }
          },
        )
    );
  }
}