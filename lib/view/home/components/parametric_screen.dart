import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/parametric_search_controller.dart';
import 'searchable_dropdown.dart'; // Make sure to import your SearchableDropdown file

class ParametricSearchScreen extends StatelessWidget {
  final ParametricSearchController controller = Get.put(ParametricSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parametric Search"),
        backgroundColor: Color(0xff7165E3),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // MDRM Number Row
              buildSearchCard(
                'MDRM Number',
                controller.selectedMdrmOperator,
                (value) => controller.selectedMdrmOperator.value = value!,
                (value) {
                  controller.selectedMdrmValue.value = value ?? "";
                  controller.mdrmTextController.text = value ?? ''; // Populate the text field with the selected value
                },
                controller.mdrmNumbers,
                controller.mdrmTextController,context
              ),
              SizedBox(height: 16),

              // Equipment Number Row
              buildSearchCard(
                'Equipment Number',
                controller.selectedEquipmentOperator,
                (value) => controller.selectedEquipmentOperator.value = value!,
                (value) {
                  controller.selectedEquipmentValue.value = value?? "";
                  controller.equipmentTextController.text = value ?? ''; // Populate the text field with the selected value
                },
                controller.equipmentNumbers,
                controller.equipmentTextController,
                context
              ),
              SizedBox(height: 16),

              // Tech ID Row
              buildSearchCard(
                'Tech ID',
                controller.selectedTechIDOperator,
                (value) => controller.selectedTechIDOperator.value = value!,
                (value) {
                  controller.selectedTechIDValue.value = value ?? "";
                  controller.techIDTextController.text = value ?? ''; // Populate the text field with the selected value
                },
                controller.techIds,
                controller.techIDTextController,context
              ),
              SizedBox(height: 16),

              // FLOC Row
              buildSearchCard(
                'FLOC',
                controller.selectedFLOCOperator,
                (value) => controller.selectedFLOCOperator.value = value!,
                (value) {
                  controller.selectedFLOCValue.value = value??"";
                  controller.flocTextController.text = value ?? ''; // Populate the text field with the selected value
                },
                controller.flocs,
                controller.flocTextController,
                context
              ),
              SizedBox(height: 24),

              // Search Button
              ElevatedButton(
                onPressed: controller.performSearch,
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff303030),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchCard(
      String label,
      RxString selectedOperator,
      ValueChanged<String?> operatorChanged,
      ValueChanged<String?> onItemSelected,
      List<String> items,
      TextEditingController textController,BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Obx(() => DecoratedBox(
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor),borderRadius: BorderRadius.circular(1),),
                  child: DropdownButtonHideUnderline(
                  
                    child: DropdownButton<String>(
                    padding: EdgeInsets.all(4),
                        
                      value: selectedOperator.value,
                      items: controller.operators.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: operatorChanged,
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(height: 8),
            SearchableDropdown(
              isItemLoaded: controller.isItemLoaded,
              hintText: 'Select $label',
              searchBoxHintText: 'Search $label',
              prefixIcon: Icon(Icons.search),
              items: items.obs,
              selectedValue: items.contains(selectedOperator.value) ? selectedOperator.value : null,
              onChanged: onItemSelected,
              isRequired: true,
            ),
          ],
        ),
      ),
    );
  }
}
