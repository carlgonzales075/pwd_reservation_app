import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';
import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/screen_change.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/reservations.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/users/utils/user_info.dart';

class CredentialsProvider extends ChangeNotifier {
  String? accessToken;
  String? refreshToken;
  int? expires;

  void updateCredentials({
    required String accessToken,
    required String refreshToken,
    required int expires,
  }) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.expires = expires;
    notifyListeners();
  }

  void resetValues() {
    accessToken = null;
    refreshToken = null;
    expires = null;
    notifyListeners();
  }
}

class DirectusAuth {
  final BuildContext context;
  late String domain;

  DirectusAuth(this.context) {
    try {
      domain = context.read<DomainProvider>().url as String;
    } catch (e) {
      CustomDialogs.customInfoDialog(
        context,
        'Domain not Set',
        'Please set the correct domain.',
        () {
          Navigator.pushNamed(context, '/domain');
        }
      );
    }
  }

  Future<Credentials> login(String? email, String? password) async {
    Future<http.Response> loginFunction(String? email, String? password) async {
      Map<String, dynamic> requestBody = {
        'email': '$email',
        'password': '$password'
      };
      final response = await http.post(
        Uri.parse('$domain/auth/login'),
        headers: {"Content-type": "application/json"},
        body: json.encode(requestBody)
      );
      return response;
    }

    void invalidCredentials(BuildContext context) {
      CustomDialogs.customErrorDialog(
        context,
        'Invalid Credentials',
        'The username/password is not valid.'
      );
    }

    final responseBody = await DirectusCalls.apiCall(
      context,
      loginFunction(email, password),
      'Login',
      (errors) => invalidCredentials(context),
      processingTitle: 'Logging in...',
      timeout: 15
    );
    return Credentials.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
  }

  Future<Credentials> refresh(String refreshToken, {String mode='json'}) async {
    Future<http.Response> refreshFunction(String refreshToken, {String mode='json'}) async {
      Map<String, dynamic> requestBody = {
        'refresh_token': refreshToken,
        'mode': mode
      };
      final response = await http.post(
        Uri.parse('$domain/auth/refresh'),
        headers: {"Content-type": "application/json"},
        body: json.encode(requestBody)
      );
      return response;
    }

    final responseBody = await DirectusCalls.apiCall(
      context,
      refreshFunction(refreshToken),
      'Refresh Login',
      (errors) {},
      showModal: false
    );
    return Credentials.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
  }

  Future<void> logOut(String? refreshToken) async {
    Future<http.Response> logoutFunction (String? refreshToken) async {
      Map<String, dynamic> requestBody = {
        'refresh_token': refreshToken
      };
      final response = await http.post(
        Uri.parse('$domain/auth/logout'),
        headers: {"Content-type": "application/json"},
        body: json.encode(requestBody)
      );
      return response;
    }
    await DirectusCalls.apiCall(
      context,
      logoutFunction(refreshToken),
      'Logout',
      (errors) {},
      successCode: 204,
      processingTitle: 'Logging out...'
    );
    if (context.mounted) {
      context.read<CredentialsProvider>().resetValues();
      context.read<StopsProvider>().resetValues();
      context.read<PassengerProvider>().resetPassenger();
      context.read<ReservationProvider>().resetReservation();
      context.read<EmployeeScreenSwitcher>().resetSwitcher();
      context.read<PartnerEmployeeProvider>().resetValues();
      context.read<VehicleRouteInfoProvider>().resetVehicleRouteInfo();
      context.read<DispatchInfoProvider>().resetDispatchInfo();
      context.read<VehicleInfoExtendedProvider>().resetVehicleInfoExtended();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void logOutDialog(BuildContext context) {
    CustomDialogs.customDecisionDialog(
      context,
      'Confirm Logout',
      'Are you sure you want to logout?',
      () {
        logOut(context.read<CredentialsProvider>().refreshToken);
      }
    );
  }

  Future<String> logInToCredentials(String email, String password) async {
    Credentials credentials = await login(email, password);
    if (context.mounted) {
      Provider.of<CredentialsProvider>(context, listen: false).updateCredentials(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        expires: credentials.expires
      );
      final String userType = await UserInfo.getUserInfo(context);
      return userType;
    }
    throw Exception('Flutter-error: Invalid context provided.');
  }

  Future<void> refreshToCredentials() async {
    String refreshToken = context.read<CredentialsProvider>().refreshToken.toString();
    Credentials credentials = await refresh(refreshToken).timeout(const Duration(seconds: 10));
    if (context.mounted) {
      Provider.of<CredentialsProvider>(context, listen: false).updateCredentials(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        expires: credentials.expires
      );
    }
  }
}