import 'dart:convert';
import 'package:http/http.dart' as http;


class BusOperations {

  static Future<String> startTrip (String domain, String accessToken, int id, String dispatchId) async {
    final requestBody = jsonEncode({
      "id": id,
      "dispatch_id": dispatchId,
      "arrival_datetime": DateTime.now().toIso8601String()
    });

    try {
      final response = await http.post(
        Uri.parse('$domain/flows/trigger/3a9d488b-8843-4e9d-917e-fc85f5fe4a71'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: requestBody
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          Map<String, dynamic> error = errors[0];
          String errorMessage = error['message'];
          String errorCode = error['extensions']['code'];
          throw Exception('$errorCode: $errorMessage ${response.headers}');
        } else {
          throw Exception('Start Trip failed: Unknown error');
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> arriveAtStation (String domain, String accessToken, int id) async {
    final requestBody = jsonEncode({
      "id": id,
      "arrival_datetime": DateTime.now().toIso8601String()
    });

    try {
      final response = await http.post(
        Uri.parse('$domain/flows/trigger/7a7dc993-2e75-4ff7-a3c2-857aff1f9c21'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: requestBody
      );
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          Map<String, dynamic> error = errors[0];
          String errorMessage = error['message'];
          String errorCode = error['extensions']['code'];
          throw Exception('$errorCode: $errorMessage ${response.headers}');
        } else {
          throw Exception('Arrive at Station failed: Unknown error');
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> departFromStation (String domain, String accessToken, int id) async {
    final requestBody = jsonEncode({
      "id": id,
      "departure_datetime": DateTime.now().toIso8601String()
    });
    try {
      final response = await http.post(
        Uri.parse('$domain/flows/trigger/7ef2c657-f7aa-48d7-b28c-e2b4459ac8cf'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: requestBody
      );
      if (response.statusCode == 200) {
        // print(response.body);
        return int.parse(response.body);
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          Map<String, dynamic> error = errors[0];
          String errorMessage = error['message'];
          String errorCode = error['extensions']['code'];
          throw Exception('$errorCode: $errorMessage ${response.headers}');
        } else {
          throw Exception('Arrive at Station failed: Unknown error');
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String> endTrip (String domain, String accessToken, int id, String dispatchId) async {
    final requestBody = jsonEncode({
      "id": id,
      "dispatch_id": dispatchId,
      "arrival_datetime": DateTime.now().toIso8601String()
    });

    try {
      final response = await http.post(
        Uri.parse('$domain/flows/trigger/5cda3454-afe4-4c4c-bea9-5ff5b3162031'),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: requestBody
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          Map<String, dynamic> error = errors[0];
          String errorMessage = error['message'];
          String errorCode = error['extensions']['code'];
          throw Exception('$errorCode: $errorMessage ${response.headers}');
        } else {
          throw Exception('Start Trip failed: Unknown error');
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
