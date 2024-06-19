import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';


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

  // void updateArrival(int id) {
  //   if (tripStops != null) {
  //     List filteredItems = tripStops!.where((item) {
  //       if (item is Map<String, dynamic>) {
  //         return item['departure_datetime'] == null;
  //       }
  //       return false;
  //     }).toList();
  //   }
  // }

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
  BuildContext context, String vehicleId,
  String routeId, String dispatchId
) async {
  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();
  
  Future<http.Response> getVehicleInfoExtendedFunction() async {
    final requestBody = jsonEncode({
      "dispatch_id": dispatchId,
      "vehicle_id": vehicleId,
      "route_id": routeId
    });
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/6502100d-b6f3-4061-9cd7-d2cf9c56ec3f'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: requestBody
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getVehicleInfoExtendedFunction(),
    'Get Vehicle Info Extended',
    (error) {},
    showModal: false
  );
  return VehicleInfoExtended.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
}