import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

class DirectusDispatch {
  static Future<List<dynamic>> getVehicleRoutes(
    BuildContext context, {
      required int limitQuery,
      required int pageQuery
    }
  ) async {
    final data = await DirectusCalls.genericGetCollection(
      context,
      collection: 'vehicle_route',
      fieldQuery: '*,vehicle_id.*',
      filterQuery: '{"route_id": {"_null": true}}',
      limitQuery: limitQuery,
      pageQuery: pageQuery
    );
    return data;
  }

  static Future<List<dynamic>> getRoutes(
    BuildContext context, {
      required int limitQuery,
      required int pageQuery
    }) async {
    final data = await DirectusCalls.genericGetCollection(
      context,
      collection: 'routes',
      fieldQuery: '*',
      filterQuery: '{"status": {"_eq": "published"}}',
      limitQuery: limitQuery,
      pageQuery: pageQuery
    );
    return data;
  }

  static Future<List<dynamic>> getDrivers(
    BuildContext context, {
      required int limitQuery,
      required int pageQuery
    }) async {
    final data = await DirectusCalls.genericGetCollection(
      context,
      collection: 'employees',
      fieldQuery: '*,user_id.*',
      filterQuery: '{"_and":[{"status": {"_eq": "published"}},'
                   '{"is_driver": {"_eq": true}},'
                   '{"assigned_vehicle_driver": {"_null": true}}]}',
      limitQuery: limitQuery,
      pageQuery: pageQuery
    );
    return data;
  }

  static Future<List<dynamic>> getConductors(
    BuildContext context, {
      required int limitQuery,
      required int pageQuery
    }) async {
    final data = await DirectusCalls.genericGetCollection(
      context,
      collection: 'employees',
      fieldQuery: '*,user_id.*',
      filterQuery: '{"_and":[{"status": {"_eq": "published"}},'
                   '{"is_conductor": {"_eq": true}},'
                   '{"assigned_vehicle_conductor": {"_null": true}}]}',
      limitQuery: limitQuery,
      pageQuery: pageQuery
    );
    return data;
  }

  static Future<void> updateVehicleRoute(BuildContext context, {
    required String vehicleRouteId,
    required String driverId,
    required String routeId,
    required String conductorId
  }) async {
    Future<http.Response> updateVehicleRouteFunc() async {
      final String domain = context.read<DomainProvider>().url.toString();
      final String accessToken = context.read<CredentialsProvider>().accessToken.toString();
      final requestBody = jsonEncode({
        'id': vehicleRouteId,
        'route_id': routeId,
        'driver_id': driverId,
        'conductor_id': conductorId
      });
      final response = await http.post(
        Uri.parse('$domain/flows/trigger/5c1597ce-3539-40fa-b752-d964a9b3fa10'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: requestBody
      );
      return response;
    }
    final responseBody = await DirectusCalls.apiCall(
      context,
      updateVehicleRouteFunc(),
      'Update Vehicle Route',
      (error) {}
    );
    final newResponseBody = jsonDecode(responseBody);
    if (newResponseBody['success']) {
      if (context.mounted) {
        CustomDialogs.customInfoDialog(
          context,
          'Dispatch Complete',
          'The vehicle has been dispatched.',
          () {
            Navigator.pop(context);
          }
        );
      }
    }
  }
}