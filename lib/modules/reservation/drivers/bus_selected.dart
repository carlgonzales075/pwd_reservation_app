import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:http/http.dart' as http;

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
}

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

Future<PassengerSeatAssignment> postSeatReservation(BuildContext context, String accessToken,
  String vehicleId,
  String stopPickUpId,
  String stopDestinationId
) async {
  try {
    final requestBody = jsonEncode(<String, dynamic> {
      "user_id": context.read<UserProvider>().userId,
      "vehicle_id": vehicleId,
      "is_pwd": context.read<PassengerProvider>().disabilityInfo != null,
      "occupied_from": stopPickUpId,
      "occupied_to": stopDestinationId
    });
    if (context.mounted) {
      print(context.read<PassengerProvider>().id);
      final response = await http.post(
        Uri.parse(
          '${DomainEnvs.getDomain()}/flows/trigger/c0d98000-1626-4b95-aea7-0107a0ba7cd2'
        ),
        headers: {
          "Content-type": 'application/json',
          "Authorization": "Bearer $accessToken"
        },
        body: requestBody
      );

      if (response.statusCode == 200) {
        return PassengerSeatAssignment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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
    } else {
      throw Exception('context not mounted correctly');
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<Passengers> getPassenger(String userId, String accessToken) async {
  try {
    final response = await http.get(
      Uri.parse('${DomainEnvs.getDomain()}/items/passengers?filter[user_id][_eq]=$userId'),
      headers: {
        "Authorization": "Bearer $accessToken"
      }
    );
    if (response.statusCode == 200) {
      print(response.body);
      return Passengers.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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
  } catch(e) {
    throw Exception(e.toString());
  }
}

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

Future<ReservationInfo> getReservationInfo (String accessToken, String seatId) async {
  try {
    final requestBody = jsonEncode(<String, dynamic> {
      "seat_id": seatId
    });
      final response = await http.post(
        Uri.parse(
          '${DomainEnvs.getDomain()}/flows/trigger/9ba5a643-bb8a-4fb3-bf97-1a868a32ed78'
        ),
        headers: {
          "Content-type": 'application/json',
          "Authorization": "Bearer $accessToken"
        },
        body: requestBody
      );

      if (response.statusCode == 200) {
        return ReservationInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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
    throw Exception(e.toString());
  }
}

Future<String?> cancelBooking(String accessToken, String passengerId, String seatId) async {
  try {
    final requestBody = jsonEncode(<String, dynamic> {
      "seat_id": seatId,
      "passenger_id": passengerId
    });
      final response = await http.post(
        Uri.parse(
          '${DomainEnvs.getDomain()}/flows/trigger/472fb2d2-8d8d-464a-842f-ea52da4b032c'
        ),
        headers: {
          "Content-type": 'application/json',
          "Authorization": "Bearer $accessToken"
        },
        body: requestBody
      );

      if (response.statusCode == 200) {
        Map<String, String> responseBody = jsonDecode(response.body) as Map<String, String>;
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
          throw Exception('Login failed: Unknown error');
        }
      }
  } catch (e) {
    throw Exception(e.toString());
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