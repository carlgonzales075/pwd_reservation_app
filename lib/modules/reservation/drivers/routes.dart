import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';

class StopsProvider extends ChangeNotifier {
  String? stopNameDestination;
  int? destinationIndex;
  String? destinationId;
  String? stopNamePickUp;
  int? pickUpIndex;
  String? pickupId;

  void updateDestination({
    required String? stopNameDestination,
    required String? destinationId,
    required int? destinationIndex,
  }) {
    this.stopNameDestination = stopNameDestination;
    this.destinationId = destinationId;
    this.destinationIndex = destinationIndex;
    notifyListeners();
  }

  void updatePickUp({
    required String? stopNamePickUp,
    required String? pickupId,
    required int? pickUpIndex
  }) {
    this.stopNamePickUp = stopNamePickUp;
    this.pickupId = pickupId!;
    this.pickUpIndex = pickUpIndex;
    notifyListeners();
  }

  void resetDestination() {
    stopNameDestination = null;
    destinationIndex = null;
    destinationId = null;
    notifyListeners();
  }

  void resetPickup() {
    stopNamePickUp = null;
    pickUpIndex = null;
    pickupId = null;
    notifyListeners();
  }

  void resetValues() {
    stopNameDestination = null;
    destinationIndex = null;
    destinationId = null;
    stopNamePickUp = null;
    pickUpIndex = null;
    pickupId = null;
    notifyListeners();
  }
}

class Stops {
  String? id;
  String? stopName;
  String? stopPointLocation;

  Stops(
    this.id,
    this.stopName,
    this.stopPointLocation
  );

  Stops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stopName = json['stop_name'];
    stopPointLocation = json['stop_point_location'];
  }
}

Future<List<Stops>> getStops(String accessToken) async {
  var url = Uri.parse('${
    DomainEnvs.getDomain()
    }/items/stops?fields=id,stop_name,stop_point_location&filter[status][_eq]=published&sort=-sort');
  try {
    final response = await http.get(
      url,
      headers: <String, String> {
        "Authorization": "Bearer $accessToken"
      }
    );
    if (response.statusCode == 200) {
      final List responseData = json.decode(response.body)['data'];
      // print(responseData['data']);
      return responseData.map((e) => Stops.fromJson(e)).toList();
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic>? errors = responseData['errors'];
      if (errors != null && errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Request User Info failed: Unknown error');
      }
    }
  } catch (e) {
    throw Exception('asd ${e.toString()}');
  }
}

class Vehicles {
  final Map<dynamic, dynamic> data;

  Vehicles(this.data);

  factory Vehicles.fromJson(dynamic json) {
    if (json is Map<dynamic, dynamic>) {
      return Vehicles(json);
    } else if (json is String) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(json);
        return Vehicles(jsonMap);
      } catch (e) {
        throw Exception('Error parsing JSON: $e');
      }
    } else {
      throw Exception('Unexpected JSON format: $json');
    }
  }

  dynamic getNestedValue(String path) {
    Map<dynamic, dynamic> currentMap = data;
    List<String> parts = path.split('.');
    for (String part in parts) {
      if (currentMap.containsKey(part)) {
        try {
          currentMap = currentMap[part];
        } on TypeError {
          return currentMap[part];
        } catch (e) {
          return e;
        }
        // currentMap = currentMap[part] as Map<dynamic, dynamic>;
      } else {
        return null; // Return null if the nested value doesn't exist
      }
    }
    return currentMap;
  }
}

Future<List<Vehicles>> postVehicles(
  String accessToken, String pickupId, String destinationId
  ) async {
  var url = Uri.parse('${
    DomainEnvs.getDomain()
    }/flows/trigger/5d1a6ed4-3ff6-4e53-a8f2-1852ec6cef63');
  try {
    final response = await http.post(
      url,
      headers: <String, String> {
        "Authorization": "Bearer $accessToken",
        "Content-type": "application/json"
      },
      body: jsonEncode(<String, String> {
        "occupied_from": pickupId,
        "occupied_to": destinationId
      })
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      return responseData.map((e) => Vehicles.fromJson(e)).toList();
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic>? errors = responseData['errors'];
      if (errors != null && errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Request User Info failed: Unknown error');
      }
    }
  } catch (e) {
    throw Exception('asd ${e.toString()}');
  }
}
