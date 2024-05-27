import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SimpleImage {
  static Future<dynamic> uploadImage(String domain, String accessToken, File selectedImage) async {

    // Send images to API endpoint
    String apiUrl = '$domain/files';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Iterate over the files with their index
    String fileName = selectedImage.path.split('/').last;

    // Determine content type
    String contentType = 'image/jpeg';
    if (fileName.toLowerCase().endsWith('.png')) {
      contentType = 'image/png';
    } else if (fileName.toLowerCase().endsWith('.gif')) {
      contentType = 'image/gif';
    } else if (fileName.toLowerCase().endsWith('.jpg') || fileName.toLowerCase().endsWith('.jpeg')) {
      contentType = 'image/jpeg';
    }

    // Add non-file properties first
    request.fields['title'] = fileName;
    // Add other properties here as needed, using index if necessary

    // Read the file as bytes
    var fileBytes = await selectedImage.readAsBytes();

    // Add the file after non-file properties
    request.files.add(http.MultipartFile.fromBytes(
      'file', // Adjusted to include index if needed
      fileBytes,
      filename: fileName,
      contentType: MediaType.parse(contentType),
    ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body)['data'];

          return data['id'].toString(); // Assuming 'id' is a String in the map
      } else {
        throw Exception('Failed to upload images: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading images: $e');
    }
  }

  static Future<Map<String, dynamic>> updateAvatar(String domain, String accessToken, String userId, String imageId) async {
    try {
      final response = await http.patch(
        Uri.parse('$domain/users/me'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          'avatar': imageId
        })
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = response.body as Map<String, dynamic>;
        return responseBody['data'];
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> errors = responseData['errors'];
        if (errors.isNotEmpty) {
          Map<String, dynamic> error = errors[0];
          String errorMessage = error['message'];
          String errorCode = error['extensions']['code'];
          throw Exception('$errorCode: $errorMessage ${response.headers}');
        } else {
          throw Exception('Updating of Avatar failed');
        }
      }
    } catch (e) {
      throw Exception('Update Avatar failed: Unknown error');
    }
  }

  static Future<File?> compressImage(File file) async {
  try {
    // Read the image from file
    Uint8List imageBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    // Resize the image (optional)
    img.Image resizedImage = img.copyResize(image, width: 800); // Adjust width as needed

    // Compress the image
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85); // Adjust quality as needed

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    String tempPath = path.join(tempDir.path, path.basename(file.path));

    // Write the compressed image to a temporary file
    File compressedFile = File(tempPath);
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  } catch (e) {
    print('Error compressing image: $e');
    return null;
  }
}
}