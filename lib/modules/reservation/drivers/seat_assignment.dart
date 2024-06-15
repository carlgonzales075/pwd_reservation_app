import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class PassengerSeatAssignment {
  String? seatAssigned;
  bool? isWaiting;

  PassengerSeatAssignment(
    this.seatAssigned,
    this.isWaiting
  );

  factory PassengerSeatAssignment.fromJson(Map<dynamic, dynamic> json) {
    final seatAssigned = json['seat_assigned'];
    final isWaiting = json['is_waiting'];

    return PassengerSeatAssignment(seatAssigned, isWaiting);
  }
}

Future<PassengerSeatAssignment> postSeatReservation(BuildContext context, String vehicleId,
  String stopPickUpId, String stopDestinationId) async {
  
  final domain = DirectusCalls.getBasics(context)[0];
  final accessToken = DirectusCalls.getBasics(context)[1];
  Future<http.Response> postSeatFunction(
    String vehicleId, String stopPickUpId, String stopDestinationId) async {
      final requestBody = jsonEncode({
        "user_id": context.read<UserProvider>().userId,
        "vehicle_id": vehicleId,
        "is_pwd": context.read<PassengerProvider>().disabilityInfo != null,
        "occupied_from": stopPickUpId,
        "occupied_to": stopDestinationId
      });
      final response = await http.post(
        Uri.parse(
          '$domain/flows/trigger/c0d98000-1626-4b95-aea7-0107a0ba7cd2'
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
    postSeatFunction(vehicleId, stopPickUpId, stopDestinationId),
    'Post Seat Reservation',
    (error) {},
    processingTitle: 'Reserving Seat...'
  );
  return PassengerSeatAssignment.fromJson(
    jsonDecode(responseBody) as Map<String, dynamic>
  );
}

Future<String?> cancelBooking(BuildContext context, String passengerId, String seatId) async {

  final domain = DirectusCalls.getBasics(context)[0];
  final accessToken = DirectusCalls.getBasics(context)[1];

  Future<http.Response> cancelBookingFunction() async {
    final requestBody = jsonEncode({
      "seat_id": seatId,
      "passenger_id": passengerId
    });
    final response = await http.post(
      Uri.parse(
        '$domain/flows/trigger/472fb2d2-8d8d-464a-842f-ea52da4b032c'
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
    cancelBookingFunction(),
    'Cancel Booking',
    (error) {},
    processingTitle: 'Cancelling...'
  );
  Map<String, dynamic> newResponseBody = jsonDecode(responseBody) as Map<String, dynamic>;
  return newResponseBody['data'];
}