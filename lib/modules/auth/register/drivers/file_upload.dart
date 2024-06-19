import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/users/utils/upload_image.dart';

class DirectusFile {
  String? id;

  DirectusFile(String id) {
    id = this.id!;
  }
}

class DirectusFileList {
  List<String>? fileIds;

  DirectusFileList(List<String> fileIds) {
    fileIds = this.fileIds!;
  }

  factory DirectusFileList.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<Map<String, dynamic>>;

    List<String> fileIds = [];
    for (var element in data) {
      fileIds.add(element['id']);
    }
    return DirectusFileList(fileIds);

  }
}

Future<dynamic> uploadImages(BuildContext context, List<File?> selectedImage) async {
  // Filter out null entries (unselected images)
  List<File> selectedFiles = selectedImage.where((image) => image != null).map((image) => image!).toList();
  final domain = context.read<DomainProvider>().url.toString();
  final accessToken = context.read<CredentialsProvider>().accessToken.toString();

  if (selectedFiles.isEmpty) {
    // No images selected
    throw Exception('No files prepared for upload.');
  }

  CustomDialogs.unskippableDialog(
    context,
    'Uploading Images',
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
  String apiUrl = '$domain/files';
  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  request.headers['Authorization'] = 'Bearer $accessToken';

  final List<String> ids = [];

  for (int index = 0; index < selectedFiles.length; index++) {
    var file = selectedFiles[index];
    String? id = await SimpleImage.uploadImage(domain, accessToken, file);
    ids.add(id.toString());
  }
  return ids;
}

class IdProcessing {
  String? id;

  IdProcessing(String? id) {
    id = this.id!;
  }

  factory IdProcessing.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final id = data['id'];
    return IdProcessing(id);
  }
}

Future<void> postImageProcessing(BuildContext context, List<String> imageIds, String passengerId, String priorityType) async {
  final domain = context.read<DomainProvider>().url.toString();
  final accessToken = context.read<CredentialsProvider>().accessToken.toString();
  
  Future<http.Response> postImageProcessingFunction() async {
    Map<String, dynamic> requestBody = {
      'id_image_front': imageIds[0],
      'id_image_back': imageIds[1],
      'id_selfie': imageIds[2],
      'passenger_id': passengerId,
      'pwd_sc_info': priorityType 
    };
    final response = await http.post(
      Uri.parse('$domain/items/id_processing'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: json.encode(requestBody)
    );
    return response;
  }
  await DirectusCalls.apiCall(
    context,
    postImageProcessingFunction(),
    'Post ID Processing',
    (error) {}
  );
}

Future<int> checkApplicationProgress(String domain, String accessToken, String passengerId) async {
  try {
    final response = await http.get(
      Uri.parse('$domain/items/id_processing?filter[is_approved][_null]'),
      headers: <String, String>{
        "Authorization": "Bearer $accessToken"
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.length;
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

Future<int> checkApplicationApproval(String domain, String accessToken, String passengerId) async {
  try {
    final response = await http.get(
      Uri.parse('$domain/items/id_processing?filter[is_approved][_eq]=true'),
      headers: <String, String>{
        "Authorization": "Bearer $accessToken"
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.length;
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