import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';

class ReservationInfo {
  String? seatName;
  String? routeName;
  String? vehicleName;
  String? busStopName;
  int? distance;

  ReservationInfo(
    this.seatName,
    this.routeName,
    this.vehicleName,
    this.busStopName,
    this.distance
  );

  factory ReservationInfo.fromJson(Map<dynamic, dynamic> json) {
    final seatName = json['seat_name'];
    final routeName = json['route_name'];
    final vehicleName = json['vehicle_name'];
    final busStopName = json['bus_stop_name'];
    final distance = json['distance'];

    return ReservationInfo(seatName, routeName, vehicleName, busStopName, distance);
  }
}

class ReservationProvider extends ChangeNotifier {
  String? seatName;
  String? routeName;
  String? vehicleName;
  String? busStopName;
  int? distance;

  void initReservation(
    String? seatName,
    String? routeName,
    String? vehicleName,
    String? busStopName,
    int? distance
  ) {
    this.seatName = seatName;
    this.routeName = routeName;
    this.vehicleName = vehicleName;
    this.busStopName = busStopName;
    this.distance = distance;
    notifyListeners();
  }

  void resetReservation() {
    seatName = null;
    routeName = null;
    vehicleName = null;
    busStopName = null;
    distance = null;
    notifyListeners();
  }
}

Future<ReservationInfo> getReservationInfo (BuildContext context, String seatId) async {
  final domain = DirectusCalls.getBasics(context)[0];
  final accessToken = DirectusCalls.getBasics(context)[1];

  Future<http.Response> getReservationFunction() async {
    final requestBody = jsonEncode(<String, dynamic> {
      "seat_id": seatId
    });
    final response = await http.post(
      Uri.parse(
        '$domain/flows/trigger/9ba5a643-bb8a-4fb3-bf97-1a868a32ed78'
      ),
      headers: {
        "Content-type": 'application/json',
        "Authorization": "Bearer $accessToken"
      },
      body: requestBody
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getReservationFunction(),
    'Get Reservation Info',
    (error) {},
    processingTitle: 'Getting Booking...'
  );
  return ReservationInfo.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
}