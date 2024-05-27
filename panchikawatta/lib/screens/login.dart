 import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:panchikawatta/main.dart';
import 'package:panchikawatta/rest/rest_api.dart';
import 'package:panchikawatta/screens/forgetpassword1.dart';
import 'package:panchikawatta/screens/sign_up1.dart';

class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _loginState();
  }
}

class _loginState extends State<login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                  controller: usernameController,
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                ),
              ),
               TextFieldContainer(
                child: TextField(
                  controller: emailController,
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgetPassword1()),
                      );
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    usernameController.text.isNotEmpty && passwordController.text.isNotEmpty
                        ? doLogin(usernameController.text, passwordController.text)
                        : Fluttertoast.showToast(
                            msg: 'All fields are required',
                            textColor: Colors.white);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    backgroundColor: const Color(0xFFFF5C01),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
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
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFFFF8000),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
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

  void doLogin(String username, String password) async {
    var res = await userLogin(username.trim(), password.trim());

    if (res['success']) {
      // Navigate to home page if login is successful
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>MyHomePage()));
    } else {
      // Show error message if login fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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

void main() {
  runApp(MaterialApp(
    home: login(),
  ));
}
