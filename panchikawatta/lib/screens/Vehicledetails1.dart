import 'package:panchikawatta/components/custom_button.dart';

import 'package:flutter/material.dart';

import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/Vehicledetails2.dart';

class Vehicledetails1 extends StatefulWidget {
  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<Vehicledetails1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Vehicle Details',
            style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 150,
                width: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'lib/src/img/vehicleDetails.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.file_upload,
                            color: Colors.black, size: 30),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,
                0,
                MediaQuery.of(context).size.width * 0.1,
                0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputFields(hintText: 'Vehicle Name', width1: 0.5),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputFields(
                            hintText: 'Type',
                            width1: 0.38,
                            suffixIcon: const Icon(Icons.expand_more,
                                size: 30, color: Color(0xCC000000))),
                        InputFields(
                            hintText: 'Make',
                            width1: 0.38,
                            suffixIcon: const Icon(Icons.expand_more,
                                size: 30, color: Color(0xCC000000))),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputFields(
                            hintText: 'Model',
                            width1: 0.38,
                            suffixIcon: const Icon(Icons.expand_more,
                                size: 30, color: Color(0xCC000000))),
                        InputFields(
                          hintText: 'Year',
                          width1: 0.38,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'License Renewal Date',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    InputFields(
                        hintText: 'DD/MM/YY',
                        width1: 0.8,
                        suffixIcon: const Icon(Icons.calendar_today)),
                    const SizedBox(height: 15),
                    const Text(
                      'Vehicle insurance renewal date',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    InputFields(
                        hintText: 'DD/MM/YY',
                        width1: 0.8,
                        suffixIcon: const Icon(Icons.calendar_today)),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Vehicledetails2()),
                            );
                          },
                          text: 'Skip',
                        ),
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Vehicledetails2()),
                            );
                          },
                          text: 'Next',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
