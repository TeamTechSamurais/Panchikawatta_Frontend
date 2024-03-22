 import 'package:panchikawatta/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/sign_up1.dart';
 

class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap your Column with SingleChildScrollView 
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFFFF5C01),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Image.asset(
                  'lib/src/img/orange logo 1.png',
                  height: 150,
                  width: 200,
                ),
              ),
              SizedBox(height: 10),
              TextFieldContainer(
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: TextButton(
                    onPressed: () { Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>MyHomePage()),
                      );
                      },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFF5C01),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "Don't have an Account?",
                      style: TextStyle(
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sign_up1()),
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFFFF8000),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onEnter: (PointerEnterEvent event) {
                        // Change color when hovering
                        // Update the text style
                        // You can directly set the color here
                        // Or you can define a new TextStyle object with the desired color
                      },
                      onExit: (PointerExitEvent event) {
                        // Restore original TextStyle when not hovering
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      width: size.width * 0.9,
      decoration: BoxDecoration(
         color: Color.fromRGBO(246, 243, 243, 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}


