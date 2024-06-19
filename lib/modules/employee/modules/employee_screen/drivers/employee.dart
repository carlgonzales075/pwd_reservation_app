import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';

class Employee {
  String id;
  bool isConductor;
  bool isDriver;
  String? assignedVehicle;

  Employee(
    this.id,
    this.isConductor,
    this.isDriver,
    this.assignedVehicle
  );

  factory Employee.fromJson(List<dynamic> json) {
    final data = json[0];
    final id = data['id'] as String;
    final isConductor = data['is_conductor'] as bool;
    final isDriver = data['is_driver'] as bool;
    dynamic assignedVehicle;
    if (isConductor) {
      final List<dynamic> conductorVehicle = data['assigned_vehicle_conductor'];
      if (conductorVehicle.length == 1) {
        assignedVehicle = data['assigned_vehicle_conductor'][0];
      }
    } else if (isDriver) {
      final List<dynamic> driverVehicle = data['assigned_vehicle_driver'];
      if (driverVehicle.length == 1) {
        assignedVehicle = data['assigned_vehicle_driver'][0];
      }
    } else {
      assignedVehicle = null;
    }
    return Employee(id, isConductor, isDriver, assignedVehicle);
  }
}

class EmployeeProvider extends ChangeNotifier {
  String? id;
  bool? isConductor;
  bool? isDriver;
  String? assignedVehicle;

  void initEmployee(
    String? id,
    bool? isConductor,
    bool? isDriver,
    String? assignedVehicle
  ) {
    this.id = id;
    this.isConductor = isConductor;
    this.isDriver = isDriver;
    this.assignedVehicle = assignedVehicle;
    notifyListeners();
  }

  void resetValues() {
    id = null;
    isConductor = null;
    isDriver = null;
    assignedVehicle = null;
    notifyListeners();
  }
}

Future<Employee> getEmployeeInfo(BuildContext context, String userId) async {
  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();
  
  Future<http.Response> getEmployeeInfoFunc() async {
    final response = await http.post(
      Uri.parse(
        '$domain/flows/trigger/4d9c603e-8185-4928-9ed3-838a35f678cd'
      ),
      headers: {
        "Content-type": 'application/json',
        "Authorization": "Bearer $accessToken"
      },
      body: jsonEncode(
        {"user_id": userId}
      )
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getEmployeeInfoFunc(),
    'Get Employee Info',
    (error) {},
    showModal: false
  );
  return Employee.fromJson(jsonDecode(responseBody) as List<dynamic>);
}