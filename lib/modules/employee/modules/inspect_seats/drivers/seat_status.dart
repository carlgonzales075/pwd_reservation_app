import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
// import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/last_update.dart';

class SeatStatus {
  const SeatStatus({
    required this.seatName,
    required this.occupancyCode,
    required this.seatType,
    required this.isUpdated,
    required this.passengerInfos,
    required this.pickup,
    required this.destination,
    required this.seatId
  });

  final String seatName;
  final int occupancyCode;
  final String seatType;
  final bool isUpdated;
  final Map<String, dynamic> passengerInfos;
  final String pickup;
  final String destination;
  final String seatId;

  factory SeatStatus.fromJson(Map<String, dynamic> json) {
    return SeatStatus(
      seatName: json['seat_name'],
      occupancyCode: json['occupancy_code'],
      seatType: json['seat_type'],
      isUpdated: json['is_updated'],
      passengerInfos: json['passenger_infos'],
      pickup: json['pickup'],
      destination: json['destination'],
      seatId: json['id']);
  }
}

// class SeatStatusList {
//   const SeatStatusList({

//   });
// }

Future<List<dynamic>> getSeatsUpdates(BuildContext context, String vehicleId,
                                      String userId) async {
  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();

  Future<http.Response> getSeatsUpdatesFunc() async {
    final requestBody = jsonEncode({
      "vehicle_id": vehicleId,
      "now": DateTime.now().toIso8601String(),
      "get_updates": false,
      "user_id": userId
    });
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/2339e35b-2d97-4ae8-bd41-799dc927c62e'),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: requestBody
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getSeatsUpdatesFunc(),
    'Get Seats Updates', (error) {},
    showModal: false
  );
  final newResponseBody = jsonDecode(responseBody) as Map<String, dynamic>;
  return newResponseBody['seats'] as List<dynamic>;
}

Future<Map<String, dynamic>> getPassengerUserInfo(BuildContext context, String userId) async {
  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();

  Future<http.Response> getPassengerUserInfoFunc() async {
    final response = await http.get(
      Uri.parse('$domain/users/$userId'),
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getPassengerUserInfoFunc(),
    'Get passenger user info',
    (error) {},
    showModal: false
  );
  final newResponseBody = jsonDecode(responseBody) as Map<String, dynamic>;
  return newResponseBody['data'];
}

Future<void> updateReadBy(BuildContext context, String userId, String seatId) async {
  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();

  Future<http.Response> updateReadByFunc() async {
    final requestBody = jsonEncode({
      "seats_id": seatId,
      "directus_users_id": userId
    });
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/c30400c2-d988-4582-86bf-8bc80508b0a3'),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: requestBody
    );
    return response;
  }
  await DirectusCalls.apiCall(
    context,
    updateReadByFunc(),
    'Update Read By',
    (error) {},
    showModal: false
  );
}