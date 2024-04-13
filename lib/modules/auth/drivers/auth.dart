import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:flutter/material.dart';

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
}

Future<Credentials> postLogin(String email, String password) async {
  Map<String, dynamic> requestBody = {
    'email': email,
    'password': password
  };
  try {
    final response = await http.post(
      Uri.parse('${DomainEnvs.getDomain()}/auth/login'),
      headers: {"Content-type": "application/json"},
      body: json.encode(requestBody)
    );
    if (response.statusCode == 200) {
      return Credentials.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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
  } catch(e) {
    throw Exception(e.toString());
  }
}

class UserProvider extends ChangeNotifier {
  String? firstName;
  String? lastName;
  String? description;
  String? avatar;
  String? email;

  void updateUser({
    required String firstName,
    required String lastName,
    String? description,
    String? avatar,
    String? email
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.description = description;
    this.avatar = avatar;
    this.email = email;
    notifyListeners();
  }
}
  //Need to remove this from this class and then update login to await this function prior to moving to the home screen.
Future<User> getUser(String accessToken) async {
  try {
    final response = await http.get(
      Uri.parse('${DomainEnvs.getDomain()}/users/me'),
      headers: <String, String>{
        "Authorization": "Bearer $accessToken"
    });
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> errors = responseData['errors'];
      if (errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Request User Info failed: Unknown error');
      }
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> postCreateUser(
    String firstName,
    String lastName,
    String email,
    String password
) async {

  // print('First Name: $firstName');
  // print('Last Name: $lastName');
  // return;
  Map<String, dynamic> requestBody = {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'role': '2120ecea-1994-43a6-b8dd-c852a37bf535'
  };
  try {
      // print(requestBody);
      final response = await http.post(
        Uri.parse('${DomainEnvs.getDomain()}/users'),
        headers: {"Content-type": "application/json"},
        body: json.encode(requestBody)
      );
      if (response.statusCode != 204) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> errors = responseData['errors'];
      if (errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Request User Info failed: Unknown error');
      }
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> logOut(String? refreshToken) async {
  Map<String, dynamic> requestBody = {
    'refresh_token': refreshToken
  };
  try {
    final response = await http.post(
      Uri.parse('${DomainEnvs.getDomain()}/auth/logout'),
      headers: {"Content-type": "application/json"},
      body: json.encode(requestBody)
    );
    if (response.statusCode != 204) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> errors = responseData['errors'];
      if (errors.isNotEmpty) {
        Map<String, dynamic> error = errors[0];
        String errorMessage = error['message'];
        String errorCode = error['extensions']['code'];
        throw Exception('$errorCode: $errorMessage ${response.headers}');
      } else {
        throw Exception('Request User Info failed: Unknown error');
      }
    }
  } catch(e) {
    throw Exception(e.toString());
  }
}

// Future<void> login(
//   TextEditingController userNameController,
//   TextEditingController passWordController,
//   bool isMounted
// ) async {
//     String email = userNameController.text;
//     String password = passWordController.text;

//     try {
//       Credentials credentials = await postLogin(email, password);
      
//       if (mounted) {
//         Provider.of<CredentialsProvider>(context, listen: false).updateCredentials(
//           accessToken: credentials.accessToken,
//           refreshToken: credentials.refreshToken,
//           expires: credentials.expires
//         );
//         await _getUserInfo(credentials.accessToken);
//       }
//       // ignore: use_build_context_synchronously
//       Navigator.pushNamed(context, '/home');
//     } catch (e) {
//       showDialog(
//         // ignore: use_build_context_synchronously
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Login Failed'),
//             content: Text(e.toString()),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         }
//       );
//     }
//   }