import 'package:delayed_display/delayed_display.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/view/home/components/ocr.dart';
import 'package:pilog_idqm/view/home/components/assest_details_screen.dart';
import 'package:pilog_idqm/view/home/components/asset_data_card.dart';
import 'package:pilog_idqm/view/home/components/home_loading_shimmer.dart';
import 'package:pilog_idqm/view/ocr.dart';
import 'package:pilog_idqm/view/profile/profile.dart';
import 'package:pilog_idqm/view/profile/settings.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class ClientMgrHomeScreen extends StatefulWidget {
  const ClientMgrHomeScreen({super.key});

  @override
  _ClientMgrHomeScreenState createState() => _ClientMgrHomeScreenState();
}

class _ClientMgrHomeScreenState extends State<ClientMgrHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientMgrHomeController>(
      init: ClientMgrHomeController(),
      builder: (controller) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text('Client Manager'),
          //   actions: [
          //     IconButton(icon:Icon(Icons.ad_units) , onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(),));
          //     },),
          //   ],
          // ),
          floatingActionButton: _buildFloatingButton(controller, context),
          body: _getSelectedPage(_selectedIndex, controller),
          bottomNavigationBar: WaterDropNavBar(
            backgroundColor: Colors.transparent,
            onItemSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedIndex: _selectedIndex,
            barItems: <BarItem>[
              BarItem(
                filledIcon: Icons.home,
                outlinedIcon: Icons.home_outlined,
              ),
              BarItem(
                filledIcon: Icons.person,
                outlinedIcon: Icons.person_outline,
                // backgroundColor: Colors.purple,
              ),
              BarItem(
                filledIcon: Icons.settings,
                outlinedIcon: Icons.settings_outlined,
                // backgroundColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getSelectedPage(int index, ClientMgrHomeController controller) {
    switch (index) {
      case 0:
        return _buildDataWidget(context, controller);
      case 1:
        return ProfileScreen();
      case 2:
        return SettingsScreen();
      default:
        return _buildDataWidget(context, controller);
    }
  }

  Widget _buildDataWidget(
      BuildContext context, ClientMgrHomeController controller) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [_buildSearchBar(controller)],
      ),
      body: Obx(() => controller.isAssetDataLoaded.value
          ? FutureBuilder(
              future: controller.getAssetdataFuture,
              initialData: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Lottie.asset('assets/images/welcome.json'),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: loadingShimmer());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView(
                    children: snapshot.data.map<Widget>((item) {
                      return GestureDetector(
                        onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => AssetDetailsScreen(
                          //         wave: item.wave,
                          //         entityName: item.entityName,
                          //         tag: item.tag,
                          //         asserTitle: item.asserTitle,
                          //         assertDescription: item.assertDescription,
                          //         fieldComments: item.fieldComments,
                          //         floorLevel: item.floorLevel,
                          //         floorLevelName: item.floorLevelName,
                          //         locationPriority: item.locationPriority,
                          //         omDepartment: item.omDepartment,
                          //         pgGrade: item.pgGrade,
                          //         pgGradeName: item.pgGradeName,
                          //         recordNo: item.recordNo,
                          //         complexName: item.complexName,
                          //         spaceLocation: item.spaceLocation,
                          //         spaceLocationName: item.spaceLocationName,
                          //         areaId: item.areaId,
                          //         areaName: item.areaName,
                          //         asBuiltRef: item.asBuiltRef,
                          //         assetQty: item.assetQty,
                          //         assetVariantDescription:
                          //             item.assetVariantDescription,
                          //         astOrgId: item.astOrgId,
                          //         cityId: item.cityId,
                          //         cityName: item.cityName,
                          //         clientQcBy: item.clientQcBy,
                          //         clientQcCommets: item.clientQcCommets,
                          //         clientQcDate: item.clientQcDate,
                          //         clientQcStatus: item.clientQcStatus,
                          //         districtId: item.districtId,
                          //         districtName: item.districtId,
                          //         drawingName: item.drawingName,
                          //         drawingNumber: item.drawingNumber,
                          //         drawingRev: item.drawingRev,
                          //         drawingType: item.drawingType,
                          //         existTagNumber: item.existTagNumber,
                          //         functionalClassification:
                          //             item.functionalClassification,
                          //         geoLocation: item.geoLocation,
                          //         geoMapLink: item.geoMapLink,
                          //         gisLinkId: item.gisLinkId,
                          //         gisLocator: item.gisLocator,
                          //         internalQcBy: item.internalQcBy,
                          //         internalQcDate: item.internalQcDate,
                          //         manufacture: item.manufacture,
                          //         manufactureYear: item.manufactureYear,
                          //         model: item.model,
                          //         orgName: item.orgName,
                          //         pinNumber: item.pinNumber,
                          //         regionId: item.regionId,
                          //         regionName: item.regionName,
                          //         sectionId: item.sectionId,
                          //         sectionName: item.sectionName,
                          //         submissionDATE: item.submissionDATE,
                          //         submissionTo: item.submissionTo,
                          //         surveyedBy: item.surveyedBy,
                          //         surveyedDate: item.surveyedDate,
                          //         uniClassCode: item.uniClassCode,
                          //         uniClassSlCode: item.uniClassSlCode,
                          //         uniClassSlTitle: item.uniClassSlTitle,
                          //         uniClassTitle: item.uniClassTitle,
                          //         uniEnCode: item.uniEnCode,
                          //         uniEnTitle: item.uniEnTitle,
                          //       ),
                          //     ),
                          //   );
                        },
                        child: DelayedDisplay(
                          child: Column(
                            children: [item],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: Lottie.asset('assets/images/welcome.json'),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: Lottie.asset('assets/images/searchdoc.json'),
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  Widget _buildFloatingButton(ClientMgrHomeController controller, context) {
    return FloatingActionBubble(
      items: <Bubble>[
        Bubble(
          title: "OCR",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.document_scanner,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  UploadAndDownloadPdfScreen()
                  //FilePickerPreviewWidget(apiUrl: "",authToken: false,),
                ));
          },
        ),
        // Bubble(
        //   title: "Logout",
        //   iconColor: Colors.white,
        //   bubbleColor: Colors.red,
        //   icon: Icons.logout,
        //   titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
        //   onPress: () {
        //    // controller.onLogout(context);
        //   },
        // ),
      ],
      animation: controller.animation,
      onPress: controller.toggleAnimation,
      iconColor: Colors.blue,
      iconData: Icons.menu,
      backGroundColor: Colors.white,
    );
  }

  Widget _buildSearchBar(ClientMgrHomeController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: Stack(
          children: [
            // Shining moving border
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Container(
                  height: 56.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.grey.shade200
                  ),
                ),
              ),
            ),
            TextField(
              controller: controller.searchController,
              onSubmitted: (value) {
                controller.onTapSearch();
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors
                    .transparent, // Keep transparent to show the moving border
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                suffixIcon: IconButton(
                  onPressed: controller.onTapSearch,
                  icon: const Icon(Icons.search_outlined),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/PiLog Logo.png', // Add your asset logo here
                    width: 24,
                    height: 24,
                    color: Colors.grey.shade600, // Adjust color to match design
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(child: AssetDataCardShimmer()),
          SizedBox(child: AssetDataCardShimmer()),
          SizedBox(child: AssetDataCardShimmer()),
        ],
      ),
    );
  }
}
