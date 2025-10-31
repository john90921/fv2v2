import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class ImageDioHandle {
  static final ImageDioHandle instance = ImageDioHandle._internal();
  final Dio dio = Dio();

  // Replace with your ImgBB API key
  final String _apiKey = 'cb320ade3104431fb0e92adeae8edc57';

  ImageDioHandle._internal();

  Future<String?> uploadToImgBB(File imageFile) async {
    try {
      // Convert image file to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final formData = FormData.fromMap({
        'key': _apiKey,
        'image': base64Image,
      });

      final response = await dio.post(
        'https://api.imgbb.com/1/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data']['url'];
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}
