import 'package:flutter/material.dart';

class OrderStatusStepper extends StatelessWidget {
  final String status;

  OrderStatusStepper({required this.status});

  @override
  Widget build(BuildContext context) {
    int currentStep;
    if (status == 'Completed') {
      currentStep = 0;
    } else if (status == 'Dispatched') {
      currentStep = 1;
    } else {
      currentStep = 2;
    }

    return Stepper(
      currentStep: currentStep,
      steps: [
        Step(
          title: Text('Processing'),
          content: Container(),
          isActive: currentStep >= 0,
          state: currentStep >= 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Dispatched'),
          content: Container(),
          isActive: currentStep >= 1,
          state: currentStep >= 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Delivered'),
          content: Container(),
          isActive: currentStep >= 2,
          state: currentStep >= 2 ? StepState.complete : StepState.indexed,
        ),
      ],
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Container();
      },
    );
  }
}
