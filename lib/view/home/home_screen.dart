import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/helpers/toasts.dart';
import 'package:pilog_idqm/view/home/components/home_loading_shimmer.dart';
import 'package:pilog_idqm/view/floc%20search/floc_opreation.dart';
import 'package:pilog_idqm/view/parametric%20search/parametric_screen.dart';
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
  // Detect device size and platform
  bool isTablet = (MediaQuery.of(context).size.shortestSide > 600) ;

  return PopScope(
     canPop: false,
    child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [_buildSearchBar(controller)],
      ),
      body: Obx(
        () => controller.isAssetDataLoaded.value
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
                    return const Center(
                      child: Image(image: AssetImage('assets/images/not_found.png')),
                    );
                  } else {
                    // Check if the device is a tablet (iPad) and adjust layout
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 2 : 1, // 2 for iPad, 1 for phone
                        crossAxisSpacing:isTablet ? 2:0.5,
                        mainAxisSpacing: isTablet ? 2:1,
                        childAspectRatio: isTablet ?MediaQuery.of(context).orientation == Orientation.portrait? 1.7 :2.7: 1.9, // Adjust card size for tablet
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data[index];
                        return DelayedDisplay(
                          child: item
                        );
                      },
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
              ),
      ),
    ),
  );
}
  Widget _buildFloatingButton(ClientMgrHomeController controller, context) {
    return FloatingActionBubble(
      items: <Bubble>[
        // Bubble(
        //   title: "OCR",
        //   iconColor: Colors.white,
        //   bubbleColor: Colors.blue,
        //   icon: Icons.document_scanner,
        //   titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
        //   onPress: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => UploadAndDownloadPdfScreen()
        //             //FilePickerPreviewWidget(apiUrl: "",authToken: false,),
        //             ));
        //   },
        // ),
        Bubble(
          title: "Paramatric Screen",
          iconColor: Colors.white,
          bubbleColor: Color(0xff7165E3),
          icon: Icons.document_scanner,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Navigator.push(
                context,
                CupertinoPageRoute<bool>(
                    builder: (_) => ParametricSearchScreen()));
          },
        ),
        Bubble(
          title: "FLOC Search",
          iconColor: Colors.white,
          bubbleColor: Color(0xff7165E3),
          icon: Icons.location_city_rounded,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Navigator.push(
                context,
                CupertinoPageRoute<bool>(
                    builder: (_) => const FLOCOperation()));
          },
        ),
        Bubble(
          title: "Logout",
          iconColor: Colors.white,
          bubbleColor: Colors.red,
          icon: Icons.logout,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
           controller.onLogout(context);
          },
        ),
      ],
      animation: controller.animation,
      onPress: controller.toggleAnimation,
      iconColor: Color(0xff7165E3),
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
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Container(
                  height: 56.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey.shade200),
                ),
              ),
            ),
            TextField(
              controller: controller.searchController,
              onSubmitted: (value) {

                if(controller.searchController.text.isNotEmpty){
                controller.onTapSearch();
                }else{
                  ToastCustom.infoToast(context, "Please enter search query");
                }
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
                  onPressed: (){
                     if(controller.searchController.text.isNotEmpty){
                controller.onTapSearch();
                }else{
                  ToastCustom.infoToast(context, "Please enter search query");
                }
                  },
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
