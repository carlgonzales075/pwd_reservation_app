import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PartnerUser {
  // final String? userId;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  // final String? email;
  final String? role;

  const PartnerUser({
    // this.userId,
    this.firstName,
    this.lastName,
    this.avatar,
    // this.email,
    this.role
  });

  factory PartnerUser.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    if (data != null) {
      // final userId = data['id'].toString();
      final firstName = data['first_name'] as String?;
      final lastName = data['last_name'] as String?;
      final avatar = data['avatar'] as String?;
      // final email = data['email'] as String?;
      // final role = data['role']['name'] as String?;
      if (firstName != null && lastName != null) {
        return PartnerUser(
          // userId: userId,
          firstName: firstName,
          lastName: lastName,
          avatar: avatar,
          // email: email,
          // role: role
        );
      }
    }
  
    throw const FormatException('Failed to load credentials.');
  }
}

class PartnerEmployeeProvider extends ChangeNotifier {
  // String? userId;
  String? firstName;
  String? lastName;
  String? avatar;
  // String? email;
  // String? role;

  void initEmployee(
    // String? userId,
    String? firstName,
    String? lastName,
    String? avatar,
    // String? email,
    // String? role,
  ) {
    // this.userId = userId;
    this.firstName = firstName;
    this.lastName = lastName;
    this.avatar = avatar;
    // this.email = email;
    // this.role = role;
    notifyListeners();
  }

  void resetValues() {
    // userId = null;
    firstName = null;
    lastName = null;
    avatar = null;
    // email = null;
    // role = null;
    notifyListeners();
  }
}

Future<PartnerUser> getPartnerUser(String domain, String accessToken, String userId) async {
  try {
    final response = await http.get(
      Uri.parse(
        '$domain/users/$userId'
      ),
      headers: {
        "Authorization": "Bearer $accessToken"
      }
    );
    if (response.statusCode == 200) {
      return PartnerUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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