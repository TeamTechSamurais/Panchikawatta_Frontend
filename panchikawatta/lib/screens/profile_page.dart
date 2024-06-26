// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/adType.dart';
import 'package:panchikawatta/screens/ad_details_sparepart.dart';
import 'package:panchikawatta/screens/buyer_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/profileImage.png'),
            ),
            SizedBox(height: 10),
            Text(
              'Anne Fernando',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BuyerProfile()),
                      );
                    },
                    child: const Text('        Buyer',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF757575))),
                  ),
                  Text('|'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Seller        ',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFFFF5C01))),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdType()),
                    );
                  },
                  text: 'Post Ad',
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Divider(
                color: Color(0x80000000),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'My Ads',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1000,
              child: AdDetailsSpareparts(),
            ),
          ],
        ),
      ),
    );
  }
}
