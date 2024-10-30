import 'dart:convert'; // For base64 encoding
import 'dart:typed_data'; // For byte conversion
import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

class LocationScreen extends StatefulWidget {
  final void Function(double latitude, double longitude) onLocationSelected;
  final String? assetName;
  final String? equipmentNo;
  final String? lat;
  final String? long;
  final String? base64Image; // Base64 string for the image
  final String? recordNo;
  final String? status;

  const LocationScreen({
    super.key,
    required this.onLocationSelected,
    this.assetName,
    this.equipmentNo,
    this.base64Image,
    this.lat,
    this.long,
    this.recordNo,
    this.status,
  });

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  BitmapDescriptor? normalMarker;
  BitmapDescriptor? shiningMarker;
  bool isShining = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _setCustomMarkers();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Function to resize the image
  Future<ui.Image> resizeImage(Uint8List data, int width, int height) async {
    ui.Codec codec = await ui.instantiateImageCodec(data,
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  // Function to add a border to the image
  Future<Uint8List> addBorderToImage(ui.Image image, double borderWidth,
      Color borderColor, bool isShining) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    if (isShining) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.outer, 7);
    }

    final size = Size(image.width.toDouble(), image.height.toDouble());
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, rect, rect, Paint());
    canvas.drawRect(rect, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // Function to set custom markers
  Future<void> _setCustomMarkers() async {
    if (widget.base64Image != null && widget.base64Image!.isNotEmpty) {
      Uint8List markerImageBytes = base64Decode(widget.base64Image!);
      ui.Image resizedImage = await resizeImage(markerImageBytes, 100, 100);

      Uint8List normalImageBytes =
          await addBorderToImage(resizedImage, 4, Colors.green, false);
      Uint8List shiningImageBytes =
          await addBorderToImage(resizedImage, 4, Colors.green.shade300, true);

      normalMarker = BitmapDescriptor.fromBytes(normalImageBytes);
      shiningMarker = BitmapDescriptor.fromBytes(shiningImageBytes);
    } else {
      normalMarker = await BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen);
      shiningMarker = await BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen);
    }

    _startBlinking();

    setState(() {});
  }

  void _startBlinking() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        isShining = !isShining;
      });
    });
  }

  // Function to open Google Maps for directions
  void _openGoogleMapsDirections() async {
    final ClientMgrHomeController homeController =
        Get.find<ClientMgrHomeController>();
    final lat = homeController.latitude.value;
    final lng = homeController.longitude.value;
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle the case where the URL can't be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ClientMgrHomeController homeController =
        Get.find<ClientMgrHomeController>();

    // Fetch location when the screen is first loaded
    homeController.getLocation();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F9D58),
        title: Text(
          "Asset Locator",
          style: AppStyles.black_20_600,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Google Map widget
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(homeController.latitude.value,
                    homeController.longitude.value),
                zoom: 17,
              ),
              mapType: MapType.satellite,
              myLocationEnabled: true,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                homeController.setGoogleMapController(controller);
              },
              minMaxZoomPreference: const MinMaxZoomPreference(17, 22),
              markers: {
                if (widget.lat != null && widget.long != null)
                Marker(
                  markerId: const MarkerId("1"),
                  position: LatLng(
                      double.parse(widget.lat??"0.00"), double.parse(widget.long??"0.00")),
                  draggable: false,
                  icon: isShining
                      ? (shiningMarker ?? BitmapDescriptor.defaultMarker)
                      : (normalMarker ?? BitmapDescriptor.defaultMarker),
                  infoWindow: InfoWindow(
                    title: "${widget.assetName} - ${widget.equipmentNo}",
                    snippet:
                        'Latitude: ${homeController.latitude.value.toStringAsFixed(6)}, '
                        'Longitude: ${homeController.longitude.value.toStringAsFixed(6)}',
                  ),
                ),
                
                  Marker(
                    markerId: const MarkerId("2"),
                    position: LatLng(homeController.latitude.value,
                        homeController.longitude.value),
                    draggable: false,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
                        .hueBlue), // Different color for distinction
                    infoWindow: const InfoWindow(
                      title: 'Second Marker',
                      snippet: 'This is the second marker.',
                    ),
                  ),
              },
            ),
          ),
          // Floating widget to display current coordinates
          Positioned(
            top: 60,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  children: [
                    Text(
                      'Latitude: ${homeController.latitude.value.toStringAsFixed(6)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Longitude: ${homeController.longitude.value.toStringAsFixed(6)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Updated Positioned widget for buttons
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //    homeController.getLocation();
                      homeController.updateAssetLocation(context,
                          latitude: homeController.latitude.string,
                          longitude: homeController.longitude.string,
                          recordNo: widget.recordNo!,
                          status: widget.status!,
                          username: "KT_VBR_MGR");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color(0xFF0F9D58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Update Location',
                      style: AppStyles.white_16_600,
                    ),
                  ),
                ),
                SizedBox(width: 10), // Add some space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openGoogleMapsDirections,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Directions',
                      style: AppStyles.white_16_600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
