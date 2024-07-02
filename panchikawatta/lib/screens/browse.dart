import 'package:panchikawatta/main.dart';
import 'package:panchikawatta/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/search_page1.dart';

class browse extends StatelessWidget {
  const browse({Key? key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            ),
            SizedBox(height: 40),
            Image.asset(
              'lib/src/img/orange logo 1.png',
              height: 150,
              width: 200,
            ),
            SizedBox(height: 90),
            Container(
              width: size.width * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            SizedBox(height: 30),
            Text(
              "or",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Container(
              width: size.width * 1.8,
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: size.width * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFFF5C01),
                    ),
                  ),
                  child: Text(
                    "Browse",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
