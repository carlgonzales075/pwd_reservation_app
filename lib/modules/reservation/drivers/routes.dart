import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';

class StopsProvider extends ChangeNotifier {
  String? stopNameDestination;
  int? destinationIndex;
  String? stopNamePickUp;
  int? pickUpIndex;

  void updateDestination({
    required String? stopNameDestination,
    required int? destinationIndex
  }) {
    this.stopNameDestination = stopNameDestination;
    this.destinationIndex = destinationIndex;
    notifyListeners();
  }

  void updatePickUp({
    required String? stopNamePickUp,
    required int? pickUpIndex
  }) {
    this.stopNamePickUp = stopNamePickUp;
    this.pickUpIndex = pickUpIndex;
    notifyListeners();
  }
}

class Stops {
  String? stopName;
  String? stopPointLocation;

  Stops(
    this.stopName,
    this.stopPointLocation
  );

  Stops.fromJson(Map<String, dynamic> json) {
    stopName = json['stop_name'];
    stopPointLocation = json['stop_point_location'];
  }
}

Future<List<Stops>> getStops(String accessToken) async {
  var url = Uri.parse('${
    DomainEnvs.getDomain()
    }/items/stops?fields=stop_name,stop_point_location&filter[status][_eq]=published&sort=-sort');
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

