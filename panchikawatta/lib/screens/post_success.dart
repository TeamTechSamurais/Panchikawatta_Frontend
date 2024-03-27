import 'package:flutter/material.dart';

class PostSuccess extends StatelessWidget {
  // ignore: use_super_parameters
  const PostSuccess({Key? key}) : super(key: key);

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
            'Ad Posted \nSuccessfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
