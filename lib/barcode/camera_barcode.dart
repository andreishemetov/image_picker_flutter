import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker_flutter/main.dart';

class CameraBarcodePage extends StatefulWidget {
  const CameraBarcodePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CameraBarcodePage> createState() => _CameraBarcodePageState();
}

class _CameraBarcodePageState extends State<CameraBarcodePage> {
  late CameraController controller;
  CameraImage? _cameraImage;
  bool isBusy = false;
  String result = "results will be shown";
  late BarcodeScanner barcodeScanner;

  @override
  void initState() {
    super.initState();
    barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);
    _intCameraController();
  }

  void _intCameraController() {
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (!isBusy) {isBusy = true, img = image, _doBarcodeScanning()}
          });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  InputImage _getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in _cameraImage!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(_cameraImage!.width.toDouble(), _cameraImage!.height.toDouble());
    final camera = cameras[0];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(_cameraImage!.format.raw);
    // if (inputImageFormat == null) return null;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: _cameraImage!.planes.first.bytesPerRow,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

    return inputImage;
  }

  @override
  void dispose() {
    barcodeScanner.close();
    controller.dispose();
    super.dispose();
  }

  _doBarcodeScanning() async {
    // InputImage inputImage = InputImage.fromFile(_image!);
    // final barcodes = await barcodeScanner.processImage(inputImage);

    // for (Barcode barcode in barcodes) {
    //   final BarcodeType type = barcode.type;
    //   switch (type) {
    //     case BarcodeType.url:
    //       BarcodeUrl barcodeUrl = barcode.value as BarcodeUrl;
    //       result = 'Url: ' + barcodeUrl.url!;
    //       break;
    //     default:
    //       break;
    //   }
    // }
    setState(() {});
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                result,
                style: const TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}
