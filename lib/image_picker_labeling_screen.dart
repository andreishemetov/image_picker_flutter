import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ImagePickerLabelingScreen extends StatefulWidget {
  const ImagePickerLabelingScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerLabelingScreen> createState() =>
      _ImagePickerLabelingScreenState();
}

class _ImagePickerLabelingScreenState extends State<ImagePickerLabelingScreen> {
  late ImagePicker _imagePicker;
  File? _image;
  String result = 'Results will be shown here';

  late ImageLabeler _imageLabeler;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    _imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
        ),
        child: _content,
      ),
    );
  }

  Widget get _content => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                width: 100,
              ),
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Stack(children: <Widget>[
                  Stack(children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/frame.png',
                        height: 510,
                        width: 500,
                      ),
                    ),
                  ]),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent),
                      onPressed: _imgFromGallery,
                      onLongPress: _imgFromCamera,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 335,
                                height: 495,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: 340,
                                height: 330,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 100,
                                ),
                              ),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      );

  _imgFromCamera() async {
    XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageLabeling();
    });
  }

  _imgFromGallery() async {
    XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doImageLabeling();
      });
    }
  }

  doImageLabeling() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels =
        await _imageLabeler.processImage(inputImage);

    result = '';
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += text + " " + confidence.toStringAsFixed(2) + "\n";
    }
    setState(() {
      result;
    });
  }
}
