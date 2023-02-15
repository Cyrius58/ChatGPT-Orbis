import 'package:chatgpt_orbis/models/models_models.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  List<ModelsModel> modelsList = [];
  String currentModel = "text-davinci-003";
  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }
}
