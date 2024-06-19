import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/errors.dart';

class DirectusCalls {
  static Future<List<dynamic>> genericGetCollection(
    BuildContext context, {
      required String collection,
      required String fieldQuery,
      required String filterQuery,
      required int limitQuery,
      required int pageQuery
    }
  ) async {
    final String domain = context.read<DomainProvider>().url.toString();
    final String accessToken = context.read<CredentialsProvider>().accessToken.toString();

    Future<http.Response> genericGetCollectionFunc() async {
      final response = await http.get(
        Uri.parse('$domain/items/$collection?fields=$fieldQuery&filter=$filterQuery&limit=$limitQuery&page=$pageQuery'),
        headers: {
          'Authorization': 'Bearer $accessToken'
        }
      );
      return response;
    }
    final String responseBody = await DirectusCalls.apiCall(
      context,
      genericGetCollectionFunc(),
      'Get Verify Requests',
      (error) {},
      showModal: false
    );
    final Map<String, dynamic> newResponseBody = jsonDecode(responseBody);
    final List data = newResponseBody['data'];
    return data;
  }

  static Future<dynamic> apiCall(
    BuildContext context,
    Future<http.Response> responseFunc,
    String functionName,
    Function(DirectusErrors)? customErrorFunc, {
    bool autoRefresh = true,
    bool showModal = true,
    int successCode = 200,
    int timeout = 60,
    String processingTitle = 'Processing...',
  }) async {
    try {
      if (showModal) {
        CustomDialogs.unskippableDialog(
          context,
          processingTitle,
          Container(
            padding: const EdgeInsets.all(20.0),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SizedBox(
                    width: 30.0, // Adjust size as needed
                    height: 30.0, // Adjust size as needed
                    child: CircularProgressIndicator(
                      color: CustomThemeColors.themeBlue,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text('Loading...'),
              ],
            ),
          ),
        );
      }

      final response = await responseFunc.timeout(Duration(seconds: timeout));

      if (context.mounted && showModal) {
        Navigator.pop(context);
      }

      if (response.statusCode == successCode) {
        return response.body;
      } else {
        if (context.mounted) {
          return _handleErrorResponse(
            context,
            response,
            responseFunc,
            functionName,
            customErrorFunc,
            autoRefresh,
            showModal,
            timeout
          );
        }
      }
    } on TimeoutException {
      if (context.mounted) {
        return _handleTimeout(context, showModal);
      }
    } catch (e) {
      if (context.mounted) {
        return _handleUnknownError(context, functionName, e, showModal);
      }
    }
  }

  static Future<dynamic> _handleErrorResponse(
    BuildContext context,
    http.Response response,
    Future<http.Response> responseFunc,
    String functionName,
    Function(DirectusErrors)? customErrorFunc,
    bool autoRefresh,
    bool showModal,
    int timeout
  ) async {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    List<dynamic>? errors = responseData['errors'];

    if (errors != null && errors.isNotEmpty) {
      Map<String, dynamic> error = errors[0];
      String errorMessage = error['message'];
      String errorCode = error['extensions']['code'];

      if (errorCode == 'TOKEN_EXPIRED') {
        if (!autoRefresh) {
          if (context.mounted) {
            Navigator.pop(context);
            CustomDialogs.customInfoDialog(
              context,
              'Login Expired',
              "Your login has expired. Please login again.",
              () {},
            );
          }
        } else {
          // Ensure you have a proper mechanism to refresh the token here.
          if (context.mounted) {
            DirectusAuth directusAuth = DirectusAuth(context);
            await directusAuth.refreshToCredentials();
            if (context.mounted) {
              final response = await responseFunc.timeout(Duration(seconds: timeout));
              return response;
            }
          }
        }
      } else {
        _handleOtherErrors(context, error, customErrorFunc, showModal, errorMessage, response);
      }
    } else {
      _handleUnknownError(context, functionName, response.headers.toString(), showModal);
    }

    return 'failed call';
  }

  static void _handleOtherErrors(
    BuildContext context,
    Map<String, dynamic> error,
    Function(DirectusErrors)? customErrorFunc,
    bool showModal,
    String errorMessage,
    http.Response response,
  ) {
    if (context.mounted) {
      if (customErrorFunc != null) {
        customErrorFunc(DirectusErrors.fromJson(error));
      } else {
        if (showModal) {
          Navigator.pop(context);
        }
        CustomDialogs.customFatalError(
          context,
          errorMessage,
          () => logError(context, error['extensions']['code'], errorMessage, response.headers.toString()),
        );
      }
    }
  }

  static Future<dynamic> _handleTimeout(BuildContext context, bool showModal) async {
    if (context.mounted) {
      if (showModal) {
        Navigator.pop(context);
      }
      CustomDialogs.customErrorDialog(
        context,
        'Connection Timeout',
        'Our server is not reachable. \nEnsure good internet connection to proceed.',
      );
    }

    return 'failed call';
  }

  static Future<dynamic> _handleUnknownError(BuildContext context, String functionName, dynamic e, bool showModal) async {
    if (context.mounted) {
      if (showModal) {
        Navigator.pop(context);
      }
      CustomDialogs.customFatalError(
        context,
        'An unknown error was encountered.',
        () => logError(context, functionName, 'Flutter-based Error: $functionName', e.toString()),
      );
    }

    return 'failed call';
  }

  static List<String> getBasics(BuildContext context) {
    final domain = context.read<DomainProvider>().url.toString();
    final accessToken = context.read<CredentialsProvider>().accessToken.toString();
    return [domain, accessToken];
  }

  static void logError(BuildContext context,
                       String? errorCode,
                       String? errorMessage,
                       String? headers) {
    if (context.mounted) {
      print(errorCode);
      print(errorMessage);
      print(headers);
    }
  }
}
