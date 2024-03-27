import 'package:flutter/material.dart';

class PostUnsuccess extends StatelessWidget {
  // ignore: use_super_parameters
  const PostUnsuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFF5C01),
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(30),
          child: const Text(
            'Ad Posting \nUnsuccessful!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
