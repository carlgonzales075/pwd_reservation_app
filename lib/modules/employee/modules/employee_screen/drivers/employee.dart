import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

Future<Employee> getEmployeeInfo(String domain, String accessToken, String userId) async {
  try {
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
    if (response.statusCode == 200) {
      return Employee.fromJson(jsonDecode(response.body) as List<dynamic>);
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