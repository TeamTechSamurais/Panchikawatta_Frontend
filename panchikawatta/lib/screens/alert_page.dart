// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/grid_block.dart';
import 'package:panchikawatta/screens/abs_light_action.dart';
import 'package:panchikawatta/screens/brake_light_action.dart';
import 'package:panchikawatta/screens/check_engine_action.dart';
import 'package:panchikawatta/screens/engine_temp_action.dart';
import 'package:panchikawatta/screens/oil_pressure_action.dart';
import 'package:panchikawatta/screens/power_steering_action.dart';
import 'package:panchikawatta/screens/seat_belt_action.dart';
import 'package:panchikawatta/screens/security_light_action.dart';
import 'package:panchikawatta/screens/tire_pressure_action.dart';
import 'package:panchikawatta/screens/washer_fluid_action.dart';

class alert_page extends StatelessWidget {
  const alert_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Quick Help',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Tap a warning light for instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                mainAxisSpacing: 1, // Space between rows
                crossAxisSpacing: 30,
                childAspectRatio: 1, // Ratio of width to height
                children: <Widget>[
                  GridBlock(
                    imagePath: 'assets/warning_lights/check_engine.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckEngineAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/engine_temp.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EngineTempAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/oil.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OilPressureAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/brake.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BrakeLightAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/abs.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ABSLightAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/tpms.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TirePressureAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/power_steering.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PowerSteeringAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/washer_fluid.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WasherFluidAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/seat_belt.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SeatBeltAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                  GridBlock(
                    imagePath: 'assets/warning_lights/security.jpg',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecurityLightAction(
                                  key: key,
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
