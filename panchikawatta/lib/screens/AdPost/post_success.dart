 import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/main.dart';
import 'package:panchikawatta/screens/profile_page.dart';
import 'package:panchikawatta/screens/search_page1.dart';

class PostSuccess extends StatelessWidget {
  const PostSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline_rounded,
                  size: 100, color: Color(0xFFFF5C01)),
              const Text(
                'Ad Posted Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFFFF5C01),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                        ads: [],
                      ),
                    ),
                    (Route<dynamic> route) =>
                        false, // This removes all routes from the stack
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
