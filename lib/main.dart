import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null ? Image.file(_image!) : const Icon(Icons.image, size: 150,),
            ElevatedButton(
              onPressed: _chooseImages,
              onLongPress: _captureImage,
              child: const Text('Choose / Capture'),
            ),
          ],
        ),
      ),
    );
  }

  _chooseImages() async {
    final img = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (img != null){
      setState(() {
        _image = File(img.path);
      });      
    }
  }

  _captureImage() async {
    final  img = await _imagePicker.pickImage(source: ImageSource.camera);
    if (img != null){
      setState(() {
        _image = File(img.path);
      });      
    }
  }
}
