import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class Passengers {
  String? id;
  String? passengerType;
  String? disabilityInfo;
  String? seatAssigned;
  bool? isWaiting;
  bool? isOnRoute;

  Passengers(
    this.id,
    this.passengerType,
    this.disabilityInfo,
    this.seatAssigned,
    this.isWaiting,
    this.isOnRoute
  );

  factory Passengers.fromJson(Map<dynamic, dynamic> json) {
    final data = json['data'][0];
    if (data != null) {
      final id = data['id'] as String;
      final passengerType = data['passenger_type'];
      final disabilityInfo = data['disability_info'];
      final seatAssigned = data['seat_assigned'];
      final isWaiting = data['is_waiting'];
      final isOnRoute = data['is_on_route'];
      return Passengers(id, passengerType, disabilityInfo, seatAssigned, isWaiting, isOnRoute);
    }
    throw const FormatException('Failed to load Passengers.');
  }

  static Future<Passengers> getPassenger(BuildContext context) async {
    final String userId = context.read<UserProvider>().userId.toString();
    final String domain = DirectusCalls.getBasics(context)[0];
    final String accessToken = DirectusCalls.getBasics(context)[1];
    Future<http.Response> getPassengerFunction() async {
      final response = await http.get(
        Uri.parse('$domain/items/passengers?filter[user_id][_eq]=$userId'),
        headers: {
          "Authorization": "Bearer $accessToken"
        }
      );
      return response;
    }
    final responseBody = await DirectusCalls.apiCall(
      context,
      getPassengerFunction(),
      'Get Passenger',
      (error) {});
    return Passengers.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
  }
}

class PassengerProvider extends ChangeNotifier {
  String? id;
  String? passengerType;
  String? disabilityInfo;
  String? seatAssigned;
  bool? isWaiting;
  bool? isOnRoute;

  void initPassenger({
    String? id,
    String? passengerType,
    String? disabilityInfo,
    String? seatAssigned,
    bool? isWaiting,
    bool? isOnRoute
  }) {
    if (id != null) {
      this.id = id;
    }
    if (passengerType != null) {
      this.passengerType = passengerType;
    }
    if (disabilityInfo != null) {
      this.disabilityInfo = disabilityInfo;
    }
    if (seatAssigned != null) {
      this.seatAssigned = seatAssigned;
    }
    if (isWaiting != null) {
      this.isWaiting = isWaiting;
    }
    if (isOnRoute != null) {
      this.isOnRoute = isOnRoute;
    }
    notifyListeners();
  }

  void assignSeat({
    required String seatAssigned,
    required bool isWaiting
  }) {
    this.seatAssigned = seatAssigned;
    this.isWaiting = isWaiting;
    notifyListeners();
  }

  void occupySeat({
    required bool isWaiting,
    required bool isOnRoute
  }) {
    this.isWaiting = isWaiting;
    this.isOnRoute = isOnRoute;
    notifyListeners();
  }

  void aloftSeat() {
    seatAssigned = null;
    isWaiting = null;
    isOnRoute = null;
    notifyListeners();
  }

  void resetPassenger() {
    id = null;
    passengerType = null;
    disabilityInfo = null;
    seatAssigned = null;
    isWaiting = null;
    isOnRoute = null;
    notifyListeners();
  }
}