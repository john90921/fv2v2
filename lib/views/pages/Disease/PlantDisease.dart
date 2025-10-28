import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fv2/models/Plant.dart';

class PlantDisease extends StatefulWidget {
  const PlantDisease({super.key});
  
  @override
  State<PlantDisease> createState() => _PlantDiseaseState();
}

class _PlantDiseaseState extends State<PlantDisease> {
  String? name;
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/home'),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
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
                  height: 200,
                  width: double.infinity,
                  child: Placeholder(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Ask Community"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Saved Results"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container( // container confidence score and plant name
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding( 
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      trailing: Text("95%"), // Confidence score
                      title: Text(
                        name ?? "Unknown", // Plant name
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(255, 255, 255, 255),
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         ExpansionTile(
                //           title: Text(
                //             "Description",
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 "This is a detailed description of the disease affecting the plant. It includes symptoms, causes, and other relevant information that can help in identifying and managing the disease effectively.",
                //                 style: TextStyle(fontSize: 16),
                //               ),
                //             ),
                //           ],
                //         ),
                //         SizedBox(height: 8.0),
                       
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
