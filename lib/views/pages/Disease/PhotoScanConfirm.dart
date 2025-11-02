import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/dio/DetectDioHandler.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/Disease/PlantDisease.dart';
import 'package:fv2/views/pages/Disease/Solution.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PhotoScanConfirm extends StatelessWidget {
  const PhotoScanConfirm({super.key, required this.newImage});
  final File? newImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Photo'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: [
          TextButton(
            onPressed: () =>{ if(context.mounted)
            {Navigator.pushNamedAndRemoveUntil(context, "/widgettree", (route) => false)}},
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (newImage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.file(
                    newImage!,
                    fit: BoxFit.contain,
                    height: 450,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(200, 45),
                ),
                onPressed: () async {
                  // Handle confirm action
                  if (newImage == null) return;
                  final _dio = DetectDioHandler.instance.dio;
                  String? name;
                  String? disease;
                  double? confidence;
                  DiseaseModel? diseaseModel;
                  bool status = true; // check if the request was successful

                  try {

                    FormData formData;

                    formData = FormData.fromMap({
                      'image': await MultipartFile.fromFile(
                        newImage!.path,
                        filename: "name",
                      ),
                    });
                    print("Sending image to API: ${newImage!.path}");

                    final predictResponse = await _dio.post(
                      '/predict',
                      data: formData,
                    );

                    final data = predictResponse.data;

                    print("Prediction Response Data: $data");
                    name = data['plant'];
                    disease = data['disease'];
                    confidence = data['confidence'];
status = true;

                    // final solutionResponse = await _dio.post(
                    //   '/getremedy',
                    //   queryParameters: {
                    //     'crop': plant,
                    //     'disease': disease,
                    //     'confidence': confidence,
                    //   },
                    // );

                    // diseaseModel = DiseaseModel.fromJson(
                    //   solutionResponse.data,
                    // );
                    // print("Disease Model: ${diseaseModel.toJson()}");

                  } on DioException catch (dioErr) {
                    print("DioException: ${dioErr.type} ${dioErr.message}");
                    if (dioErr.response != null) {
                      print(
                        "Dio response: ${dioErr.response?.statusCode} ${dioErr.response?.data}",
                      );
                    }
                  } catch (e, st) {
                    print("Error during AP1I POST request: $e\n$st");
                  }

                  if(context.mounted && status){Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoaderOverlay(
                        child: PlantDisease(
                          name: name ?? "Unknown",
                          disease: disease ?? "Unknown",
                          image: newImage!,
                          confidence: confidence ?? 0.0,
                          // diseaseModel: diseaseModel,
                        ),
                      ),
                    ),
                  );}
                  else if (context.mounted) {
                    
showMessage(context: context, message: "Error during disease detection. Please try again.", isError: true);
                      
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
      ),
    );
  }
}
