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
      home: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
          ),
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
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
  late ImagePicker _imagePicker;
  File? _image;
  String result = 'Results will be shown here';

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  _imgFromCamera() async {
    XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
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

  //TODO image labeling code here
  doImageLabeling() async {
  }
}
