import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
import 'package:pwd_reservation_app/modules/users/utils/user_info.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class LastUpdateProvider extends ChangeNotifier {
  int? hasUpdates;
  int? prevUpdates;
  bool? showNotif;
  Timer? _timer;
  bool? isPlayed;

  void initNow(
    int? hasUpdates,
    int? prevUpdates,
    bool? showNotif
  ) {
    this.hasUpdates = hasUpdates;
    this.showNotif = showNotif;
    this.prevUpdates = prevUpdates;
    isPlayed = false;
    _autoDismissNotif();
    notifyListeners();
  }

  void updateNow(
    int? hasUpdates,
    bool? showNotif
  ) {
    prevUpdates = hasUpdates;
    this.hasUpdates = hasUpdates;
    this.showNotif = showNotif;
    _autoDismissNotif();
    notifyListeners();
  }

  void updateIsPlayed() {
    isPlayed = true;
    // notifyListeners();
  }

  void resetIsPlayed() {
    isPlayed = false;
    notifyListeners();
  }

  void hideNotif() {
    showNotif = false;
    notifyListeners();
  }

  void _autoDismissNotif() {
    Future.delayed(const Duration(seconds: 10), () {
      if (showNotif as bool) {
        hideNotif();
      }
    });
  }

  void resetNotif() {
    showNotif = true;
    _autoDismissNotif();
    notifyListeners();
  }

  void resetValues() {
    hasUpdates = null;
    showNotif = null;
    notifyListeners();
  }

  void startPeriodicUpdates(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      await checkAndUpdate(context);
    });
  }

  void stopPeriodicUpdates(BuildContext context) {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  Future<void> checkAndUpdate(BuildContext context) async {
    try {
      LastUpdate hasUpdates = await checkUpdates(
        context,
        context.read<VehicleRouteInfoProvider>().vehicleId as String,
        DateTime.now(),
        context.read<UserProvider>().userId as String
      );
      if (context.mounted) {
        if (hasUpdates.updates != prevUpdates) {
          updateNow(
            hasUpdates.updates,
            hasUpdates.showNotif
          );
          if (context.mounted) {
            await UserInfo.getTripInfo(context);
          }
        }
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class LastUpdate {
  final int updates;
  final bool showNotif;
  
  const LastUpdate({
    required this.updates,
    required this.showNotif
  });

  factory LastUpdate.fromJson(Map<String, dynamic> json) {
    return LastUpdate(
      updates: json['has_updates'],
      showNotif: json['has_updates'] > 0
    );
  } 
}

Future<LastUpdate> checkUpdates(BuildContext context, String vehicleId,
                                DateTime lastUpdate, String userId) async {

  final String domain = context.read<DomainProvider>().url.toString();
  final String accessToken = context.read<CredentialsProvider>().accessToken.toString();

  Future<http.Response> checkUpdatesFunc() async {
    final requestBody = jsonEncode({
      "vehicle_id": vehicleId,
      "now": lastUpdate.toIso8601String(),
      "get_updates": true,
      "user_id": userId
    });
    final response = await http.post(
      Uri.parse('$domain/flows/trigger/2339e35b-2d97-4ae8-bd41-799dc927c62e'),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: requestBody
    );
    return response;
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    checkUpdatesFunc(),
    'Check Updates',
    (error) {},
    showModal: false
  );
  return LastUpdate.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
}