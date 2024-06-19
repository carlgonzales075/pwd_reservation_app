import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

class UserProvider extends ChangeNotifier {
  String? userId;
  String? firstName;
  String? lastName;
  String? description;
  String? avatar;
  String? email;
  String? role;

  void updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    String? description,
    String? avatar,
    String? email,
    String? role
  }) {
    this.userId = userId;
    this.firstName = firstName;
    this.lastName = lastName;
    this.description = description;
    this.avatar = avatar;
    this.email = email;
    this.role = role;
    notifyListeners();
  }

  void updateAvatar(
    String avatar
  ) {
    this.avatar = avatar;
    notifyListeners();
  }
}

class DirectusUser {
  final BuildContext context;
  late String domain;

  DirectusUser(this.context) {
    domain = context.read<DomainProvider>().url.toString();
  }

  Future<User> getUser(String accessToken) async {
    Future<http.Response> getUserFunction(String accessToken) async {
      final response = await http.get(
        Uri.parse('$domain/users/me?fields=*,role.name'),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
      });
      return response;
    }
    final responseBody = await DirectusCalls.apiCall(
      context,
      getUserFunction(accessToken),
      'Get User Profile',
      (errors) {}
    );
    return User.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
  }

  Future<void> createUser(String firstName, String lastName, String email,
      String password) async {
    Future<http.Response> createUserFunction(
      String firstName, String lastName,
      String email, String password) async {

        Map<String, dynamic> requestBody = {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'role': "dc504f63-7040-45c6-9aa8-f9adb6bf57aa"
        };
        final response = await http.post(
          Uri.parse('$domain/users'),
          headers: {"Content-type": "application/json"},
          body: json.encode(requestBody)
        );
        return response;
    }
    final response = await DirectusCalls.apiCall(
      context,
      createUserFunction(firstName, lastName, email, password),
      'Create User',
      (errors) {
        if (errors.code == 'RECORD_NOT_UNIQUE') {
          CustomDialogs.unskippableDecisionDialog(
            context,
            'You\'re already registered.',
            const Text('We detected you\'re email in our database. would you like to login instead?'),
            () {
              Navigator.pushReplacementNamed(context, '/');
            }
          );
        }
      },
      successCode: 204,
      processingTitle: 'Registering...'
    );
    if (context.mounted) {
      if (response != 'failed call') {
        DirectusAuth directusAuth = DirectusAuth(context);
        final String userType = await directusAuth.logInToCredentials(email, password);
        if (context.mounted) {
          if (userType == 'Passenger') {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pushReplacementNamed(context, '/employee-home');
          }
        }
      }
    }
  }
}