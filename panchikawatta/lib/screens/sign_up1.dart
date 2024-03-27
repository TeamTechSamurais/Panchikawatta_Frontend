import 'dart:io';
import 'package:panchikawatta/screens/login.dart';
import 'package:panchikawatta/screens/sign_up2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class sign_up1 extends StatefulWidget {
  const sign_up1({Key? key}) : super(key: key);

  @override
  _SignUp1State createState() => _SignUp1State();
}

class _SignUp1State extends State<sign_up1> {
  String? imagePath;

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
                      "Fill your Profile",
                      style: TextStyle(
                        color: Color(0xFFFF5C01),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 30),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[400],
                      child: ClipOval(
                        child: GestureDetector(
                          onTap: () async {
                            final imagePicker = ImagePicker();
                            final XFile? pickedFile =
                                await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              setState(() {
                                imagePath = pickedFile.path;
                              });
                            }
                          },
                          child: imagePath != null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(File(imagePath!)),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[400],
                                  child: Image.asset(
                                    'lib/src/img/profile.png',
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: -10,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () async {
                            final imagePicker = ImagePicker();
                            final XFile? pickedFile =
                                await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              setState(() {
                                imagePath = pickedFile.path;
                              });
                            }
                          },
                          child: Image.asset(
                            'lib/src/img/uploadicon.png',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10, width: 40),
              Row(
                children: [
                  Expanded(
                    child: TextFieldContainer(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "FirstName",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFieldContainer(
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "LastName",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFieldContainer(
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "UserName",
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
              TextFieldContainer(
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "+94",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: ' Province',
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      value: null,
                      onChanged: (String? newValue) {},
                      items: <String>[
                        'Western',
                        'Central',
                        'Southern',
                        'Northern',
                        'Eastern',
                        'North Western',
                        'North Central',
                        'Uva',
                        'Sabaragamuwa',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: ' District',
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      value: null,
                      onChanged: (String? newValue) {},
                      items: <String>[
                        'Colombo',
                        'Gampaha',
                        'Kalutara',
                        'Kandy',
                        'Matale',
                        'Nuwara Eliya',
                        'Galle',
                        'Matara',
                        'Hambantota',
                        'Jaffna',
                        'Killinochchi',
                        'Mannar',
                        'Vavuniya',
                        'Mulaitivu',
                        'Batticaloa',
                        'Ampara',
                        'Trincomalee',
                        'Kurunegala',
                        'Puttalam',
                        'Anuradhapura',
                        'Polonnaruwa',
                        'Badulla',
                        'Monaragala',
                        'Ratnapura',
                        'Kegalle'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: size.width * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sign_up2()),
                      );
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFFF5C01)),
                    ),
                    child: Text(
                      "Next",
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
                      "Already have an Account?",
                      style: TextStyle(
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFFFF5C01),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onEnter: (PointerEnterEvent event) {},
                      onExit: (PointerExitEvent) {},
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
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 243, 243, 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
