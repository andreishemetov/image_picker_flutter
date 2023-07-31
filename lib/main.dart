import 'package:flutter/material.dart';
import 'image_picker_labeling_screen.dart';
import 'camera_labeling_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadCameras();
  // runApp(const ImagePickerLabelingScreen());
  runApp(const CameraLabelingScreen());
}

