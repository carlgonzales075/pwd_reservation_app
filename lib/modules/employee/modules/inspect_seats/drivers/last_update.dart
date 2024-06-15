import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
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
        context.read<DomainProvider>().url as String,
        context.read<CredentialsProvider>().accessToken as String,
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
          VehicleRouteInfo vehicleRouteInfo = await getVehicleRouteInfo(
            context.read<DomainProvider>().url as String,
            context.read<CredentialsProvider>().accessToken as String,
            context.read<EmployeeProvider>().id as String
          );
          if (context.mounted) {
            context.read<VehicleRouteInfoProvider>().initVehicleRouteInfo(
              vehicleRouteInfo.routeId,
              vehicleRouteInfo.vehicleId,
              vehicleRouteInfo.driverId,
              vehicleRouteInfo.conductorId,
              vehicleRouteInfo.currentStopId,
              vehicleRouteInfo.goingToBusStopId
            );
            DispatchInfo dispatchInfo = await getDispatchInfo(
              context.read<DomainProvider>().url as String,
              context.read<CredentialsProvider>().accessToken as String,
              vehicleRouteInfo.vehicleId as String,
              vehicleRouteInfo.routeId as String
            );
            if (context.mounted) {
              context.read<DispatchInfoProvider>().initDispatchInfo(
                dispatchInfo.dispatchId,
                dispatchInfo.dateOfDispatch
              );
              VehicleInfoExtended vehicleInfoExtended = await getVehicleInfoExtended(
                context.read<DomainProvider>().url as String,
                context.read<CredentialsProvider>().accessToken as String,
                vehicleRouteInfo.vehicleId as String,
                vehicleRouteInfo.routeId as String,
                dispatchInfo.dispatchId as String
              );
              if (context.mounted) {
                context.read<VehicleInfoExtendedProvider>().initVehicleInfoExtended(
                  vehicleInfoExtended.vehicleName,
                  vehicleInfoExtended.vehiclePlateNumber,
                  vehicleInfoExtended.vehicleImageId,
                  vehicleInfoExtended.driverUserId,
                  vehicleInfoExtended.conductorUserId,
                  vehicleInfoExtended.normalSeatsRemaining,
                  vehicleInfoExtended.pwdSeatsRemaining,
                  vehicleInfoExtended.tripStops
                );
              }
            }
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

Future<LastUpdate> checkUpdates(
  String domain, String accessToken,
  String vehicleId, DateTime lastUpdate, String userId) async {
    final requestBody = jsonEncode({
      "vehicle_id": vehicleId,
      "now": lastUpdate.toIso8601String(),
      "get_updates": true,
      "user_id": userId
    });
    try {
      final response = await http.post(
        Uri.parse('$domain/flows/trigger/2339e35b-2d97-4ae8-bd41-799dc927c62e'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: requestBody
      );
      if (response.statusCode == 200) {
        final LastUpdate responseBody = LastUpdate.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        return responseBody;
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          Map<String, dynamic> error = errors[0];
          String errorMessage = error['message'];
          String errorCode = error['extensions']['code'];
          throw Exception('$errorCode: $errorMessage ${response.headers}');
        } else {
          throw Exception('Getting Seats Unknown Error Encountered.');
        }
      }
    } catch (e) {
      throw Exception('Error in Checking Updates: $e');
    }
}