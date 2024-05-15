import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class VehicleInfoExtended {
  String? vehicleName;
  String? vehiclePlateNumber;
  String? vehicleImageId;
  String? driverUserId;
  String? conductorUserId;
  int? normalSeatsRemaining;
  int? pwdSeatsRemaining;
  List<dynamic>? tripStops;

  VehicleInfoExtended(
    this.vehicleName,
    this.vehiclePlateNumber,
    this.vehicleImageId,
    this.driverUserId,
    this.conductorUserId,
    this.normalSeatsRemaining,
    this.pwdSeatsRemaining,
    this.tripStops
  );

  factory VehicleInfoExtended.fromJson(Map<String, dynamic> json) {
    final data = json;
    final vehicleName = data['vehicle_name'];
    final vehiclePlateNumber = data['vehicle_plate_number'];
    final vehicleImageId = data['vehicle_image'];
    final driverUserId = data['vehicle_driver']['user_id'];
    final conductorUserId = data['vehicle_conductor']['user_id'];
    final normalSeatsRemaining = data['normal_remaining_seats'];
    final pwdSeatsRemaining = data['pwd_remaining_seats'];
    final tripStops = data['trip_stops'];
    return VehicleInfoExtended(
      vehicleName, vehiclePlateNumber,
      vehicleImageId, driverUserId, conductorUserId, normalSeatsRemaining,
      pwdSeatsRemaining, tripStops
    );
  }
}

class VehicleInfoExtendedProvider extends ChangeNotifier {
  String? vehicleName;
  String? vehiclePlateNumber;
  String? vehicleImageId;
  String? driverUserId;
  String? conductorUserId;
  int? normalSeatsRemaining;
  int? pwdSeatsRemaining;
  List<dynamic>? tripStops;

  void initVehicleInfoExtended(
    String? vehicleName,
    String? vehiclePlateNumber,
    String? vehicleImageId,
    String? driverUserId,
    String? conductorUserId,
    int? normalSeatsRemaining,
    int? pwdSeatsRemaining,
    List<dynamic>? tripStops
  ) {
    this.vehicleName = vehicleName;
    this.vehiclePlateNumber = vehiclePlateNumber;
    this.vehicleImageId = vehicleImageId;
    this.driverUserId = driverUserId;
    this.conductorUserId = conductorUserId;
    this.normalSeatsRemaining = normalSeatsRemaining;
    this.pwdSeatsRemaining = pwdSeatsRemaining;
    this.tripStops = tripStops;
    notifyListeners();
  }

  void resetVehicleInfoExtended() {
    vehicleName = null;
    vehiclePlateNumber = null;
    vehicleImageId = null;
    driverUserId = null;
    conductorUserId = null;
    normalSeatsRemaining = null;
    pwdSeatsRemaining = null;
    tripStops = null;
    notifyListeners();
  }
}

Future<VehicleInfoExtended> getVehicleInfoExtended(
  String domain, String accessToken, String vehicleId,
  String routeId, String dispatchId
) async {
  final requestBody = jsonEncode({
    "dispatch_id": dispatchId,
    "vehicle_id": vehicleId,
    "route_id": routeId
  });
  try {
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/6502100d-b6f3-4061-9cd7-d2cf9c56ec3f'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: requestBody
    );

    if (response.statusCode == 200) {
      return VehicleInfoExtended.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> errors = responseData['errors'];
      if (errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Login failed: Unknown error');
      }
    }
  } catch (e) {
    throw Exception('Uncatched Error: $e');
  }
}