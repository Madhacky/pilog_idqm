import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/parametric_search_controller.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import 'package:pilog_idqm/view/floc%20search/floc_opreation.dart';
import '../../global/widgets/searchable_dropdown.dart'; // Make sure to import your SearchableDropdown file

class ParametricSearchScreen extends StatefulWidget {
  const ParametricSearchScreen({super.key});

  @override
  State<ParametricSearchScreen> createState() => _ParametricSearchScreenState();
}

class _ParametricSearchScreenState extends State<ParametricSearchScreen> {
  final ParametricSearchController controller =
      Get.put(ParametricSearchController());

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
              buildSearchCard('MDRM Number', controller.selectedMdrmOperator,
                  (value) => controller.selectedMdrmOperator.value = value!,
                  (value) {
                controller.selectedMdrmValue.value = value ?? "";
                controller.mdrmTextController.text = value ??
                    ''; // Populate the text field with the selected value
              }, controller.mdrmNumbers, controller.mdrmTextController, context,
                  controller.isMdrmNumbersLoaded),
              const SizedBox(height: 16),

              // Equipment Number Row
              buildSearchCard(
                  'Equipment Number',
                  controller.selectedEquipmentOperator,
                  (value) => controller.selectedEquipmentOperator.value =
                      value!, (value) {
                controller.selectedEquipmentValue.value = value ?? "";
                controller.equipmentTextController.text = value ??
                    ''; // Populate the text field with the selected value
              },
                  controller.equipmentNumbers,
                  controller.equipmentTextController,
                  context,
                  controller.isequipmentNumbersLoaded),
              const SizedBox(height: 16),

              // Tech ID Row
              buildSearchCard('Tech ID', controller.selectedTechIDOperator,
                  (value) => controller.selectedTechIDOperator.value = value!,
                  (value) {
                controller.selectedTechIDValue.value = value ?? "";
                controller.techIDTextController.text = value ??
                    ''; // Populate the text field with the selected value
              }, controller.techIds, controller.techIDTextController, context,
                  controller.istechIdsLoaded),
              const SizedBox(height: 16),

              // FLOC Row
              buildSearchCard('FLOC', controller.selectedFLOCOperator,
                  (value) => controller.selectedFLOCOperator.value = value!,
                  (value) {
                controller.selectedFLOCValue.value = value ?? "";
                controller.flocTextController.text = value ??
                    ''; // Populate the text field with the selected value
              }, controller.flocs, controller.flocTextController, context,
                  controller.isflocsLoaded),
              const SizedBox(height: 24),

              // Search Button
              ElevatedButton(
                onPressed: () => controller.performSearch(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff303030),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Search',style: AppStyles.white_15_600,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //build bar code scanner
  Widget buildBarcodeScanner() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.barcodeScannerController,
                decoration: InputDecoration(
                  labelText: "Tag Number",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // IconButton(
            //     onPressed: () async{await controller.scanBarcodeNormal(context);},
            //     icon: const Icon(CupertinoIcons.doc_text_viewfinder))
          ],
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
      TextEditingController textController,
      BuildContext context,
      RxBool isItemLoaded) {
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
                      border: const OutlineInputBorder(),
                      suffixIcon: label.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,color: AppColors.absoluteBlack,),
                              onPressed: () {
                                textController.clear();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.all(4),
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
                  ),
                ),
                // Clear button for the dropdown
                Obx(
                  () => selectedOperator.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            // Reset the dropdown value to an empty string or null
                            selectedOperator.value = '';
                            operatorChanged(null); // Trigger the change
                          },
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(
              () => SearchableDropdown(
                isItemLoaded: isItemLoaded,
                hintText: 'Select $label',
                searchBoxHintText: 'Search $label',
                prefixIcon: const Icon(Icons.search),
                items: items.obs,
                selectedValue: items.contains(selectedOperator.value)
                    ? selectedOperator.value
                    : null,
                onChanged: onItemSelected,
                isRequired: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
