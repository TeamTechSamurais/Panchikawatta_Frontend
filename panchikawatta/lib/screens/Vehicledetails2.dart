import 'package:panchikawatta/screens/Vehicledetails1.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';

import 'package:panchikawatta/screens/Registration_successs.dart';

class Vehicledetails2 extends StatefulWidget {
  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<Vehicledetails2> {
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
                    InputFields(hintText: 'Mileage', width1: 0.8),
                    const SizedBox(height: 20),
                    InputFields(hintText: 'Avg distance per week', width1: 0.8),
                    const SizedBox(height: 20),
                    InputFields(hintText: 'Last Service date', width1: 0.8),
                    const SizedBox(height: 20),
                    InputFields(hintText: 'Battery Condition', width1: 0.8),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ClipRRect(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Vehicledetails2()), // Navigate to Vehicledetails1 screen
                            );
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 249, 248, 247),
                            ),
                          ),
                          child: Text(
                            "+ Add Vehicle",
                            style: TextStyle(
                                color: Color.fromARGB(255, 234, 137, 9)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Back',
                        ),
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registraion_success()),
                            );
                          },
                          text: 'Register',
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
