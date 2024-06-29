import 'dart:io';
//import 'dart:js';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:panchikawatta/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:panchikawatta/screens/profile_page.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

Future<UserCredential?> createAccount(String username, String password, String email, String? imagePath) async {
  try {  
    print("Attempting to create user with email: $email");

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      print("User is successfully created");

      await user.updateDisplayName(username);  // Update the user's display name (this is a method from the Firebase Auth package

      String? downloadUrl;
      if (imagePath != null) {
        // Upload the image to Firebase Storage
        File file = File(imagePath);
        TaskSnapshot snapshot = await _storage.ref('profile_pictures/${user.uid}').putFile(file);   // Upload the file to the profile_pictures folder in Firebase Storage

        // Get the download URL
        downloadUrl = await snapshot.ref.getDownloadURL();
      }

      // send user data to the firebase cloud firestore database
      await _firestore.collection("users").doc(_auth.currentUser?.uid).set({
        "name": username,
        "email": email,
        "profile_picture": downloadUrl,
      });

      return userCredential;
    } else {
      print("Some error happend");
      return userCredential;
    }
  } catch (e) {
    print(e);
    return null;
  }
}


Future<UserCredential?> logout(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try{
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => login()));
    });
    print("Logout successful");
    return null;
  }catch (e){
    print(e);
    return null;
  }
}



void updateUser(
    BuildContext context,
    String password,
    String? newImagePath,
    String? newFirstName,
    String? newLastName,
    String? newUserName,
    String? newEmail,
    String? newPhone,
    String? newDistrict,
    String? newProvince) async {

  User? user = _auth.currentUser;
  if (user == null) {
    print("No user is currently signed in.");
    return;
  }

  String email = user.email!;
  final data = await ApiServices.getUserByEmail(email);
  String? downloadUrl;

  try {

    // Update email if it has changed
    if (newEmail != null && newEmail.isNotEmpty && newEmail != user.email) {
      await user.verifyBeforeUpdateEmail(newEmail);
      print("Email updated to $newEmail");
    }

    // Update profile picture if a new one is provided
    if (newImagePath != null && newImagePath.isNotEmpty) {
      File file = File(newImagePath);
      TaskSnapshot snapshot = await _storage.ref('profile_pictures/${user.uid}').putFile(file);
      downloadUrl = await snapshot.ref.getDownloadURL();
      print("Profile picture updated");
    }

    // Update Firestore with new user data
    await _firestore.collection("users").doc(user.uid).update({
      "email": newEmail ?? user.email,
      "name": newUserName ?? data["username"],
      "profile_picture": downloadUrl ?? data["profile_picture"],
    });
    print("Firestore updated");

    // Update display name
    if (newUserName != null && newUserName.isNotEmpty) {
      await user.updateDisplayName(newUserName);
      print("Display name updated");
    }

    // Prepare user data for PostgreSQL update
    Map<String, dynamic> userData = {
      "firstName": newFirstName ?? data["firstName"],
      "lastName": newLastName ?? data["lastName"],
      "username": newUserName ?? data["username"],
      //"password": newPassword ?? password,
      "email": newEmail ?? email,
      "phone": newPhone ?? data["phone"],
      "district": newDistrict ?? data["district"],
      "province": newProvince ?? data["province"],
    };

    // Update PostgreSQL database
    Future<Map<String, dynamic>> updated = ApiServices.updateUser(email, userData);

    updated.then((result) {
      print("User data updated successfully");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("User data updated successfully"),
            actions: [
              CustomButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                text: 'OK'
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      print("User data update failed: $error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("User data update failed. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    });
  } catch (e) {
    print("Error: $e");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
