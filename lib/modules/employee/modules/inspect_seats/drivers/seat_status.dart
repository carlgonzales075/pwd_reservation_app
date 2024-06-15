import 'dart:convert';

import 'package:http/http.dart' as http;
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

Future<List<dynamic>> getSeatsUpdates(
  String domain, String accessToken,
  String vehicleId, String userId) async {
    final requestBody = jsonEncode({
      "vehicle_id": vehicleId,
      "now": DateTime.now().toIso8601String(),
      "get_updates": false,
      "user_id": userId
    });
    try {
      final response = await http.post(
        Uri.parse('$domain/flows/trigger/2339e35b-2d97-4ae8-bd41-799dc927c62e'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: requestBody
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return responseBody['seats'] as List<dynamic>;
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          Map<String, dynamic> error = errors[0];
          String errorMessage = error['message'];
          String errorCode = error['extensions']['code'];
          throw Exception('$errorCode: $errorMessage ${response.headers}');
        } else {
          throw Exception('Getting Seats Unknown Error Encountered.');
        }
      }
    } catch (e) {
      throw Exception('Error in getting Seat Updates: $e');
    }
}

Future<Map<String, dynamic>> getPassengerUserInfo(String domain, String accessToken, String userId) async {
  try {
    final response = await http.get(
      Uri.parse('$domain/users/$userId'),
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      return responseBody['data'];
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> errors = responseData['errors'];
      if (errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Getting Seats Unknown Error Encountered.');
      }
    }
  } catch (e) {
    throw Exception('Error on getting passenger\'s user info: $e');
  }
}

Future<void> updateReadBy(String domain, String accessToken, String userId, String seatId) async {
  final requestBody = jsonEncode({
    "seats_id": seatId,
    "directus_users_id": userId
  });

  try {
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/c30400c2-d988-4582-86bf-8bc80508b0a3'),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: requestBody
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> errors = responseData['errors'];
      if (errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Reading Status Unknown Error Encountered.');
      }
    }
  } catch (e) {
    throw Exception('Error on unreading status: $e');
  }
}