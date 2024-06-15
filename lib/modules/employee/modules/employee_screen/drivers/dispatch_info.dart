import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DispatchInfo {
  String? dispatchId;
  DateTime? dateOfDispatch;

  DispatchInfo(
    this.dispatchId,
    this.dateOfDispatch,
  );

  factory DispatchInfo.fromJson(List<dynamic> json) {
    final data = json[0];
    if (data != null) {
      final dispatchId = data['id'];
      final dateOfDispatch = DateTime.parse(data['date_of_dispatch']);
      return DispatchInfo(dispatchId, dateOfDispatch);
    } else {
      throw Exception('The dispatch info cannot be parsed correctly.');
    }
  }
}

class DispatchInfoProvider extends ChangeNotifier {
  String? dispatchId;
  DateTime? dateOfDispatch;

  void initDispatchInfo(
    String? dispatchId,
    DateTime? dateOfDispatch
  ) {
    this.dispatchId = dispatchId;
    this.dateOfDispatch = dateOfDispatch;
    notifyListeners();
  }

  void resetDispatchInfo() {
    dispatchId = null;
    dateOfDispatch = null;
    notifyListeners();
  }
}

Future<DispatchInfo> getDispatchInfo(String domain, String accessToken, String vehicleId, String routeId) async {
  final requestBody = jsonEncode({
    "vehicle_id": vehicleId,
    "route_id": routeId
  });
  try {
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/484b8df0-8c1e-4362-84da-a1af5377d81b'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: requestBody
    );

    if (response.statusCode == 200) {
      return DispatchInfo.fromJson(jsonDecode(response.body) as List<dynamic>);
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
    throw Exception('Uncatched Error: $e');
  }
}