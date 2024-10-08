import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';

class LocationScreen extends StatelessWidget {
  final void Function(double latitude, double longitude) onLocationSelected;
  const LocationScreen({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClientMgrHomeController homeController = Get.find<ClientMgrHomeController>();

    // Fetch location when the screen is first loaded
    homeController.getLocation();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F9D58),
        title: const Text("Google Maps"),
      ),
      body: Obx(
        () => GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(homeController.latitude.value, homeController.longitude.value),
            zoom: 14,
          ),
          mapType: MapType.satellite,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            homeController.setGoogleMapController(controller);
          },
          markers: {
            Marker(
              markerId: const MarkerId("1"),
              position: LatLng(homeController.latitude.value, homeController.longitude.value),
              draggable: true,
              onDragEnd: (LatLng newPosition) {
                homeController.updateMarkerPosition(newPosition);
                // _showSuccessDialog(context, newPosition);
              },
              onTap: () {
                homeController.animateCameraTo(
                  LatLng(homeController.latitude.value, homeController.longitude.value),
                  12.0,
                );
              },
            ),
            Marker(
              markerId: const MarkerId("2"),
              position: const LatLng(40.7128, -74.0060), // New York City
            ),
            Marker(
              markerId: const MarkerId("3"),
              position: const LatLng(34.0522, -118.2437), // Los Angeles
            ),
          },
        ),
      ),
    );
  }

  // void _showSuccessDialog(BuildContext context, LatLng newPosition) {
  //   CoolAlert.show(
  //     context: context,
  //     type: CoolAlertType.success,
  //     title: "Click ok to confirm",
  //     onConfirmBtnTap: () {
  //       onLocationSelected(newPosition.latitude, newPosition.longitude);
  //       Navigator.pop(context);
  //     },
  //   );
  // }
}
