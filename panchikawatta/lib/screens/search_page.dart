import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/chat_screen.dart';
import 'package:panchikawatta/screens/sign_up1.dart';

class search_page extends StatefulWidget {
  const search_page({Key? key}) : super(key: key);

  @override
  _search_pageState createState() => _search_pageState();
}

class _search_pageState extends State<search_page> {
  // const search_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(), // Empty container to push PopupMenuButton to the right
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text('Sign Out'),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, "login");  
                    },
                  ),
                  PopupMenuItem(
                    child: Text('Sign Up'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sign_up1()),
                        
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: Text('SignIn'),
                    onTap: () {
                      Navigator.pushNamed(context, "login");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Center(
        // child: Text('Search Page Content'),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen()));         
          },
          child: const Text('chat'),
        ),
      ),
    );
  }
}
