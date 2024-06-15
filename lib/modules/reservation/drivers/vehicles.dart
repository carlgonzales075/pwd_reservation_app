import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';

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

Future<List<Vehicles>> postVehicles(BuildContext context, String pickupId, String destinationId, bool isPwd) async {
  final domain = DirectusCalls.getBasics(context)[0];
  final accessToken = DirectusCalls.getBasics(context)[1];

  Future<http.Response> postVehiclesFunction() async {
    var url = Uri.parse('$domain/flows/trigger/5d1a6ed4-3ff6-4e53-a8f2-1852ec6cef63');
    final response = await http.post(
      url,
      headers: <String, String> {
        "Authorization": "Bearer $accessToken",
        "Content-type": "application/json"
      },
      body: jsonEncode(<String, dynamic> {
        "occupied_from": pickupId,
        "occupied_to": destinationId,
        "is_pwd": isPwd
      })
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    postVehiclesFunction(),
    'Post Vehicles', (error) {},
    processingTitle: 'Getting Vehicles...',
    showModal: false  
  );
  final List<dynamic> responseData = json.decode(responseBody)['data'];
  return responseData.map((e) => Vehicles.fromJson(e)).toList();
}