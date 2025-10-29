import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/dio/DetectDioHandler.dart';
import 'package:fv2/models/Plant.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/Disease/DiseaseDetailPage.dart';
import 'package:fv2/views/pages/Disease/Solution.dart';
import 'package:fv2/views/pages/PostFormPage.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PlantDisease extends StatefulWidget {
  const PlantDisease({
    super.key,
    required this.image,
    required this.disease,
    required this.name,
    required this.confidence,
  });
  final String name;
  final String disease;
  final File image;
  final double confidence;
  @override
  State<PlantDisease> createState() => _PlantDiseaseState();
}

class _PlantDiseaseState extends State<PlantDisease> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            if (mounted) {
  Navigator.pop(context);
}
          },
        ),
        
         actions: [TextButton(
          child: const Text('Done', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, "/widgettree", (route) => false);
            }
          },
        ),]
    
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  //image disease
                  height: 200,
                  width: 200,
                  child: Image.file(
                    widget.image,
                  width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                           if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostFormPage(
                    imageFile:widget.image
                  ),
              ));}
            


                        },
                        child: Text("Ask Community"),
                      ),
                      if (widget.disease !=
                          "Unknown Disease") // only can save result if disease is known
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Saved Results"),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  // container confidence score and plant name
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      trailing: Text(
                        "${widget.confidence.toStringAsFixed(2)} % confidence",
                      ), // Confidence score
                      title: Text(
                        "Disease : ${widget.disease}", // Plant name
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("Plant : ${widget.name}"),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if ((widget.disease == "Unknown Disease" || widget.disease == "Unknown")) ...[
                  ElevatedButton(
                    onPressed: () async {
                      final _dio = DetectDioHandler.instance.dio;
                      String plant = widget.name;
                      String disease = widget.disease;
                      double confidence = widget.confidence;
                      DiseaseModel? diseaseModel;
                      bool success = false;
                          context.loaderOverlay.show();
                      try {
                    
                        final solutionResponse = await _dio.post(
                          '/getremedy',
                          queryParameters: {
                            'crop': plant,
                            'disease': disease,
                            'confidence': confidence,
                          },
                        );

                        diseaseModel = DiseaseModel.fromJson(
                          solutionResponse.data,
                        );

                        
                        print("Disease Model: ${diseaseModel.toJson()}");
                        success = true;
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
                      context.loaderOverlay.hide();
                      if (success && mounted) {
                            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiseaseDetailPage(
                       disease: diseaseModel!,
                       
                      ),
                    ),
                  );
                      }
                      else{
                          if (mounted) {
 showMessage(context: context, message: "Error fetching disease information. Please try again.", isError: true);
}
                      }
                      print("Ask for more information about the disease");
                    },
                    child: Text("Get More Information"),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
