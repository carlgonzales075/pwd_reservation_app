import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';


class VehicleRouteInfo {
  String? routeId;
  String? vehicleId;
  String? driverId;
  String? conductorId;
  String? currentStopId;
  String? goingToBusStopId;

  VehicleRouteInfo(
    this.routeId,
    this.vehicleId,
    this.driverId,
    this.conductorId,
    this.currentStopId,
    this.goingToBusStopId
  );

  factory VehicleRouteInfo.fromJson(List<dynamic> json) {
    final data = json[0];
    if (data != null) {
      final routeId = data['route_id'];
      final vehicleId = data['vehicle_id'];
      final driverId = data['driver_id'];
      final conductorId = data['conductor_id'];
      final currentStopId = data['current_stop'] ?? '';
      final goingToBusStopId = data['going_to_bus_stop'] ?? '';
      return VehicleRouteInfo(
        routeId, vehicleId, driverId,
        conductorId, currentStopId, goingToBusStopId
      );
    } else {
      throw Exception('The vehicle route info cannot be parsed correctly.');
    }
  }
}

class VehicleRouteInfoProvider extends ChangeNotifier {
  String? routeId;
  String? vehicleId;
  String? driverId;
  String? conductorId;
  String? currentStopId;
  String? goingToBusStopId;

  void initVehicleRouteInfo(
    String? routeId,
    String? vehicleId,
    String? driverId,
    String? conductorId,
    String? currentStopId,
    String? goingToBusStopId,
  ) {
    this.routeId = routeId;
    this.vehicleId = vehicleId;
    this.driverId = driverId;
    this.conductorId = conductorId;
    this.currentStopId = currentStopId;
    this.goingToBusStopId = goingToBusStopId;
    notifyListeners();
  }

  void resetVehicleRouteInfo() {
    routeId = null;
    vehicleId = null;
    driverId = null;
    conductorId = null;
    currentStopId = null;
    goingToBusStopId = null;
    notifyListeners();
  }
}

Future<VehicleRouteInfo> getVehicleRouteInfo(BuildContext context, String employeeId) async {
  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();
  
  Future<http.Response> getVehicleRouteInfoFunc() async {
    final requestBody = jsonEncode({
      "employee_id": employeeId
    });
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/581e4ba8-7ff0-43e1-97e3-b03f15e2ed61'),
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
    getVehicleRouteInfoFunc(),
    'Get Vehicle Route Info',
    (error) {},
    showModal: false
  );
  return VehicleRouteInfo.fromJson(jsonDecode(responseBody) as List<dynamic>);
}