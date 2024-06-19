import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';

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

Future<PartnerUser> getPartnerUser(BuildContext context, String userId) async {
  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();
  
  Future<http.Response> getPartnerUser() async {
    final response = await http.get(
      Uri.parse(
        '$domain/users/$userId'
      ),
      headers: {
        "Authorization": "Bearer $accessToken"
      }
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getPartnerUser(),
    'Get Partner User',
    (error) {},
    showModal: false
  );
  return PartnerUser.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
}