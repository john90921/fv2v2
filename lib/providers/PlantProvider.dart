import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/Plant.dart';


class PlantProvider extends ChangeNotifier {

  List<Plant> _plants = [];
  bool _disposed = false;
  List<Plant> get plants => _plants;
  void setPlants(List<Plant> plants) {
    _plants = plants;
    notifyListeners();
  }

   @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  addNewPlant({
    required String name,
    required String imagePath,
  }) async{
      FormData formData = FormData.fromMap({
        'name': name,
        if (imagePath != null)
          'image': await MultipartFile.fromFile(
            imagePath,
            filename: 'image.jpg',
          ),
      });
      try{
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/plant", data: formData),
      );
      if (result.status) {
        final plant = Plant.fromMap(result.data);
        _plants.insert(0, plant);
        notifyListeners();
      } else {
        print("error ${result.message}");

      }
      } catch(e){
        print("error $e");
      }



  }
}