import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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

Future<dynamic> uploadImages(String domain, String accessToken, List<File?> selectedImage) async {
  // Filter out null entries (unselected images)
  List<File> selectedFiles = selectedImage.where((image) => image != null).map((image) => image!).toList();

  if (selectedFiles.isEmpty) {
    // No images selected
    throw Exception('No files prepared for upload.');
  }

  // Send images to API endpoint
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

Future<void> postImageProcessing(String domain, String accessToken, List<String> imageIds, String passengerId) async {
  Map<String, dynamic> requestBody = {
    'id_image_front': imageIds[0],
    'id_image_back': imageIds[1],
    'id_selfie': imageIds[2],
    'passenger_id': passengerId,  
  };
  try {
    final response = await http.post(
      Uri.parse('$domain/items/id_processing'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: json.encode(requestBody)
    );
    if (response.statusCode == 200) {
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