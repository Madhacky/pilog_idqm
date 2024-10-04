// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:idxp/moduels/idxp/controllers/home_controller.dart';
// import 'package:idxp/moduels/idxp/models/home_state_model.dart';
// import 'package:pilog_idqm/helpers/toasts.dart';

// class LocationScreen extends StatefulWidget {
//   final void Function(double latitude, double longitude) onLocationSelected;
//   const LocationScreen({Key? key, required this.onLocationSelected})
//       : super(key: key);

//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   HomeController homeController = Get.find<HomeController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(       
//         backgroundColor: const Color(0xFF0F9D58),
//         title: const Text("Google Maps"),
//       ),
//       body: BlocBuilder<HomeController, HomeStateModel>(
//         bloc: homeController,
//         builder: (context, state) {
//           return SizedBox(
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(state.latitude ?? 0, state.longitude ?? 0),
//                 zoom: 14,
//               ),
//               mapType: MapType.satellite,
//               myLocationEnabled: true,
//               compassEnabled: true,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("1"),
//                   position: LatLng(state.latitude ?? 0, state.longitude ?? 0),
//                   draggable: true,
//                   onDragEnd: (LatLng newPosition) {
//                     // _showSuccessDialog(context, newPosition);
//                   },
//                   onTap: () {
//                     _controller.future.then((value) {
//                       value.animateCamera(
//                         CameraUpdate.newCameraPosition(
//                           CameraPosition(
//                             target: LatLng(
//                                 state.latitude ?? 0, state.longitude ?? 0),
//                             zoom: 12.0,
//                           ),
//                         ),
//                       );
//                     });
//                   },
//                 ),
//                   Marker(
//                   markerId: const MarkerId("2"),
//                   position: LatLng(40.7128, -74.0060), 
//                   onTap: () {
//                     // Handle marker tap if needed
//                   },
//                 ),
//                 Marker(
//                   markerId: const MarkerId("3"),
//                   position: LatLng(34.0522, -118.2437), 
//                   onTap: () {
//                     // Handle marker tap if needed
//                   },
//                 ),
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // void _showSuccessDialog(BuildContext context, LatLng newPosition) {
//   //   ToastCustom.show(
//   //     context: context,
//   //     type: CoolAlertType.success,
//   //     title: "Click ok to confirm",
//   //     onConfirmBtnTap: () {
//   //       widget.onLocationSelected(newPosition.latitude, newPosition.longitude);
//   //       Navigator.pop(context);
//   //     },
//   //   );
//   // }
// }
