import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParametricSearchController extends GetxController {
  // Dummy data for dropdown fields
  final List<String> mdrmNumbers = ['MDRM001', 'MDRM002', 'MDRM003', 'MDRM004'];
  final List<String> equipmentNumbers = ['EQ001', 'EQ002', 'EQ003', 'EQ004'];
  final List<String> techIds = ['Tech01', 'Tech02', 'Tech03', 'Tech04'];
  final List<String> flocs = ['FLOC1', 'FLOC2', 'FLOC3', 'FLOC4'];

  // Operators including the new ones
  final List<String> operators = [
  '',
    '=',
    'LIKE',
    'IN',
    'NOT IN',
    'IS',
    'IS NOT',
    'NOT LIKE',
  ];

  // Selected values
  var selectedMdrmOperator = ''.obs;
  var selectedEquipmentOperator = ''.obs;
  var selectedTechIDOperator = ''.obs;
  var selectedFLOCOperator = ''.obs;

  var selectedMdrmValue = ''.obs;
  var selectedEquipmentValue = ''.obs;
  var selectedTechIDValue = ''.obs;
  var selectedFLOCValue = ''.obs;

  // Text controllers for manual input
  var mdrmTextController = TextEditingController();
  var equipmentTextController = TextEditingController();
  var techIDTextController = TextEditingController();
  var flocTextController = TextEditingController();

  RxBool isItemLoaded = true.obs; // Used to determine if items are loaded

  // Search function
  void performSearch() {
    print("MDRM: ${mdrmTextController.text}, Operator: ${selectedMdrmOperator.value}");
    print("Equipment: ${equipmentTextController.text}, Operator: ${selectedEquipmentOperator.value}");
    print("Tech ID: ${techIDTextController.text}, Operator: ${selectedTechIDOperator.value}");
    print("FLOC: ${flocTextController.text}, Operator: ${selectedFLOCOperator.value}");
  }
}
