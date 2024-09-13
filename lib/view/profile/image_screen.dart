import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _imageFile;

  // Method to capture photo from camera
  Future<void> capturePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File imageFile = File(image.path);
      _cropImage(imageFile);
    }
  }

  // Method to crop the image
  Future<void> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepPurple,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    if (croppedImage != null) {
      setState(() {
        _imageFile = croppedImage;
      });
      uploadToAPI(croppedImage);
    }
  }

  // Method to upload the image to the API
  Future<void> uploadToAPI(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('YOUR_API_ENDPOINT'));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully!')));
    } else {
      print('Image upload failed');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image upload failed!')));
    }
  }

  // Method to view the image
  void viewImage() {
    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageViewScreen(imageFile: _imageFile!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image to view!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera & Crop Example'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the captured or cropped image
            _imageFile != null
                ? Image.file(_imageFile!)
                : Icon(Icons.camera_alt, size: 150, color: Colors.grey),
            SizedBox(height: 20),
            // Button to capture photo
            ElevatedButton.icon(
              onPressed: capturePhoto,
              icon: Icon(Icons.camera_alt),
              label: Text('Capture Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shadowColor: Colors.white
                // primary: Colors.deepPurple, // background color
                // onPrimary: Colors.white, // text color
              ),
            ),
            SizedBox(height: 10),
            // Button to view the image
            ElevatedButton.icon(
              onPressed: viewImage,
              icon: Icon(Icons.remove_red_eye),
              label: Text('View Image'),
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.deepPurple,
                shadowColor: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate screen to display the image in full view
class ImageViewScreen extends StatelessWidget {
  final File imageFile;

  ImageViewScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Image'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
