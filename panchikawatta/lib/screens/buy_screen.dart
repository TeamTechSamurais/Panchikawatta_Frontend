import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;


class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

bool loading = false;

setLoading(bool value){
  loading = value;
}
late final String userId;
Future<void> getDetails() async {
  try{
    setLoading(true);
    final url = "http://localhost:8000/spare-parts/:id";
    final response = await http.get(Uri.parse(url), headers: {'userId': widget.userId});  
  } catch(error){
    print(error);
  }
}

class _BuyScreenState extends State<BuyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            size: 30,
          ),
        ),
        title: Text(
          'Details',
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xffFF5C01)),
        ),
        actions: [
          Icon(
            Icons.favorite_border_sharp,
            size: 35,
            color: Color(0xffFF5C01),
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 290,
                width: double.infinity,
                child: Swiper(
                  itemWidth: 300.0,
                  itemHeight: 200.0,
                  itemBuilder: (context, index) {
                    return Image.asset(
                        height: 250, width: 200, 'assets/engine_image.png');
                  },
                  itemCount: 10,
                  control: SwiperControl(color: Colors.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.015,
              ),
              Container(
                height: 50,
                child: OtpTextField(
                  filled: true,
                  fillColor: Color(0xffD9D9D9),
                  numberOfFields: 4,
                  showFieldAsBox: true,
                  focusedBorderColor: Color(0xffD9D9D9),
                  cursorColor: Colors.transparent,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.015,

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: Colors.black,
                  thickness: 1.6,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.015,

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xffFF5C01)),
                      child: Center(
                        child: Text('Buy it now',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Toyota CHR',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        Container(
                          height: 28,
                          width: 1,
                          decoration:
                              BoxDecoration(color: Colors.black.withOpacity(0.5)),
                        ),
                        Text('2017',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Rs850,000.00',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                        Row(
                          children: [
                            Image.asset(
                                height: 36,
                                width: 36,
                                'assets/phone-filled 1.png'),
                            SizedBox(
                              width: 3,
                            ),
                            Image.asset(
                                height: 36,
                                width: 36,
                                'assets/message-filled 1.png')
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.015,

              ),
          
              Row(
                children: [
                  Text('Part or Accessory Type: ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  Text('Engine',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.015,

              ),
              Row(
                children: [
                  Image.asset(height: 20, width: 15, 'assets/Location_icon.png'),
                  Text('Location:',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  Text(' Moratuwa,Colombo',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.018,

              ),
              Row(
                children: [
                  Container(
                    height: 34,
                    width: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1.5)),
                    child: Center(
                      child: Text('New',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                    ),
                  ),
                  Container(
                    height: 34,
                    width: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1.5)),
                    child: Center(
                      child: Text('Auto',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                    ),
                  ),
                  Container(
                    height: 34,
                    width: 81,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1.5)),
                    child: Center(
                      child: Text('Hybrid',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.015,

              ),
              Text('Description',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFF5C01))),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.012,

              ),
              Text(
                'AQUA / PRIUS 20 / PRIUS 30 / INSITE ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.035,

              ),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1.5,)),
                  SizedBox(width: 15,),
                  Text(
                    'See more',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffFF5C01)),
                  ),
                  SizedBox(width: 5,),
                  Icon(CupertinoIcons.chevron_down,color: Color(0xffFF5C01),size: 20,),
                  SizedBox(width: 15,),
                  Expanded(child: Divider(thickness: 1.5,)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
