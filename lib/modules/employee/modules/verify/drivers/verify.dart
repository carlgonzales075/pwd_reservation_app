import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';

class DirectusVerification {
  static Future<List<dynamic>> getVerifyRequests(
    BuildContext context, {
      required int limitQuery,
      required int pageQuery
    }
  ) async {
    final data = await DirectusCalls.genericGetCollection(
      context,
      collection: 'id_processing',
      fieldQuery: '*,passenger_id.*.*',
      filterQuery: '{"status": {"_eq": "draft"}}',
      limitQuery: limitQuery,
      pageQuery: pageQuery
    );
    return data;

  }

  static Future<bool> checkRfidUniqueness(
    BuildContext context,
    {
      required String rfidTag,
      required String passengerId
    }
  ) async {
    Future<http.Response> checkRfidUniquenessFunc() async {
        final String domain = context.read<DomainProvider>().url.toString();
        final String accessToken = context.read<CredentialsProvider>().accessToken.toString();

        final requestBody = jsonEncode({
          'rfid_tag': rfidTag
        });
        final response = await http.post(
          Uri.parse('$domain/flows/trigger/3882dd8a-c235-4974-b9e5-a4b6eb3640c8'),
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
        checkRfidUniquenessFunc(),
        'Check RFID Uniqueness',
        (error) {}
      );
      final List<dynamic> newResponseBody = jsonDecode(responseBody);
      final bool isUnique = newResponseBody.isEmpty;
      if (isUnique) {
        return isUnique;
      } else {
        return newResponseBody[0]['id'] == passengerId;
      }
  }

  static Future<bool> postVerification(
    BuildContext context, {
      required bool isApproved,
      required String pwdScInfo,
      required String validatorComments,
      required String processingId,
      required String passengerId,
      required String rfidTag
    }) async {
      Future<http.Response> postVerificationFunc() async {
        final String domain = context.read<DomainProvider>().url.toString();
        final String accessToken = context.read<CredentialsProvider>().accessToken.toString();

        final requestBody = jsonEncode({
          'is_approved': isApproved,
          'pwd_sc_info': pwdScInfo,
          'validator_comments': validatorComments,
          'processing_id': processingId,
          'passenger_id': passengerId,
          'rfid_tag': rfidTag
        });
        final response = await http.post(
          Uri.parse('$domain/flows/trigger/a3cd22ac-e8b7-48ae-ac3d-f0cac2f3b97d'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: requestBody
        );
        return response;
      }
      final String responseBody = await DirectusCalls.apiCall(
        context,
        postVerificationFunc(),
        'Post Approval/Rejection of Verification',
        (error) {}
      );
      final Map<String, dynamic> newResponseBody = jsonDecode(responseBody);
      final bool success = newResponseBody['success'];
      return success;
    }
}