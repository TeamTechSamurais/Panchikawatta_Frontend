import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:momin/ui/Bottom_Bar/Screens/Buy_Screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_rounded,
          size: 30,
        ),
        elevation: 0,
        actions: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Buyer',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffFF5C01)),
                  ),
                  Text(
                    'Anne_fernando82',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/profile_image.png'),
              ),
            ],
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xffFF5C01),
                      size: 30,
                    ),
                    filled: true,
                    fillColor: Color(0xffFAFAFA),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                    hintText: "Search",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Color(0xffFAFAFA))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Color(0xffFAFAFA)))),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Image.asset(
                      height: 20, width: 15, 'assets/Location_icon.png'),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Location',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffFF5C01)),
                  ),
                  Spacer(),
                  Text(
                    'Filter & sort',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffFF5C01)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.grid_view_outlined,
                    color: Color(0xffFF5C01),
                    size: 23,
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 8,
                  physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10

                    ),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyScreen()));
                        },
                        child: Container(

                          width: 82,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffEBEBEB)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  height: 73,
                                  width: 81,
                                  'assets/engine_image.png'),
                              Text(
                                'Toyota CHR',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                'Rs. 850,000.00',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                '2014',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Text(
                                'Hybrid',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),

                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// Container(
// height: 218,
// width: 82,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// color: Color(0xffEBEBEB)
// ),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Image.asset(
// height: 73,
// width: 81,
// 'assets/engine_image.png'),
// Text(
// 'Toyota CHR',
// style: TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.w400,
// color: Colors.black),
// ),
// Text(
// 'Rs. 850,000.00',
// style: TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.w400,
// color: Colors.black),
// ),
// Text(
// '2014',
// style: TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.w400,
// color: Colors.black),
// ),
// Text(
// 'Hybrid',
// style: TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.w400,
// color: Colors.black),
// ),
//
// ],
// ),
// );
