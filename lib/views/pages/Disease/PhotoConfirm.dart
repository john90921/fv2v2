import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/dio/DetectDioHandler.dart';

class PhotoConfirm extends StatelessWidget {
  const PhotoConfirm({super.key, required this.newImage});
  final File? newImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Photo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (newImage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(
                  newImage!,
                  fit: BoxFit.contain,
                  height: 300,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(200, 45),
              ),
              onPressed: () async{
                // Handle confirm action
                if (newImage == null) return;
                final _dio =  DetectDioHandler.instance.dio;

                try{
                   FormData formData;

               formData = FormData.fromMap({
                 'image' : await MultipartFile.fromFile(newImage!.path, filename: newImage!.path.split('/').last),
                });
                  final response = await _dio.post('/predict', data: formData);
                  final data = response.data;
                  print("API POST Response: $data");
                }
                catch(e){
                  print("Error during API POST request: $e");
                }

                // Navigator.pop(context, true);
              },
              child: const Text('Confirm'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 45),
              ),
              onPressed: () {
                // Handle retake action
                Navigator.pop(context, false);
              },
              child: const Text('Retake'),
            ),
          ],
        ),
      ),
    );
  }
}
