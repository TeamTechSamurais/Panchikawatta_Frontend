class NearestReminder {
  final String type;
  final String date;

  NearestReminder({required this.type, required this.date});

  factory NearestReminder.fromJson(Map<String, dynamic> json) {
    return NearestReminder(
      type: json['type'],
      date: json['date'],
    );
  }
}

class Vehicle {
  final int vehicleId;
  final int userId;
  final String model;
  final int year;
  final int milagePerWeek;
  final String licenceDate;
  final String insuranceDate;
  final String batteryCondition;
  final String lastServiceDate;
  final String make;
  final String type;
  final List<String> imageUrls;
  final NearestReminder? nearestReminder;

  Vehicle({
    required this.vehicleId,
    required this.userId,
    required this.model,
    required this.year,
    required this.milagePerWeek,
    required this.licenceDate,
    required this.insuranceDate,
    required this.batteryCondition,
    required this.lastServiceDate,
    required this.make,
    required this.type,
    required this.imageUrls,
    required this.nearestReminder,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'],
      userId: json['userId'],
      model: json['model'],
      year: json['year'],
      milagePerWeek: json['milagePerWeek'],
      licenceDate: json['licenceDate'],
      insuranceDate: json['insuranceDate'],
      batteryCondition: json['batteryCondition'],
      lastServiceDate: json['lastServiceDate'],
      make: json['make'],
      type: json['type'],
      imageUrls: List<String>.from(json['imageUrls']),
      nearestReminder: json['nearestReminder'] != null
          ? NearestReminder.fromJson(json['nearestReminder'])
          : null,
    );
  }

  get id => null;
}
