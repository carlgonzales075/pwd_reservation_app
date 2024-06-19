import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';

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

Future<DispatchInfo> getDispatchInfo(BuildContext context, String vehicleId, String routeId) async {
  final domain = context.read<DomainProvider>().url.toString();
  final accessToken = context.read<CredentialsProvider>().accessToken.toString();

  Future<http.Response> getDispatchInfoFunction() async {
    final requestBody = jsonEncode({
      "vehicle_id": vehicleId,
      "route_id": routeId
    });
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/484b8df0-8c1e-4362-84da-a1af5377d81b'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: requestBody
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getDispatchInfoFunction(),
    'Get Dispatch Info', 
    (error) {},
    showModal: false
  );
  
  return DispatchInfo.fromJson(jsonDecode(responseBody));
}