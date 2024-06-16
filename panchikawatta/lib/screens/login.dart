import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panchikawatta/screens/auth_functions.dart';
import 'package:panchikawatta/screens/chat_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: isLoading? Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 20,
          width: MediaQuery.of(context).size.width / 20,
          child: CircularProgressIndicator(),
        ),
      ) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: ()  {
                if(_email.text.isNotEmpty && _password.text.isNotEmpty) {
                  setState(() {
                    isLoading = true;
                  });
                  login(_email.text, _password.text).then((user)  {
                    if(user != null) {
                      print("Login successful");
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen()));
                    } else {
                      print("Login failed");
                      setState(() {
                        isLoading = false;
                      });
                    }
                  });
                } else {
                  print("Please enter username and password");
                }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}