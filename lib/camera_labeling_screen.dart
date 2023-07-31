import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';


late List<CameraDescription> _cameras;

Future<void> loadCameras() async {
  _cameras = await availableCameras();
} 

class CameraLabelingScreen extends StatefulWidget {
  const CameraLabelingScreen({Key? key}) : super(key: key);

  @override
  State<CameraLabelingScreen> createState() => _CameraLabelingScreenState();
}

class _CameraLabelingScreenState extends State<CameraLabelingScreen> {
  
  late CameraController controller;

  CameraImage? _cameraImage;
  String result = "results to be shown here";

  late ImageLabeler _imageLabeler;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    _imageLabeler = ImageLabeler(options: options);

    controller = CameraController(_cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) {
        if (!_isBusy){
          _cameraImage = image;
        doImageLabeling();
        _isBusy = true;
        }
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

  doImageLabeling() async {
    result = "";
    InputImage inputImage = getInputImage();
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
    _isBusy = false;
  }

  
  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in _cameraImage!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(_cameraImage!.width.toDouble(), _cameraImage!.height.toDouble());

    final camera = _cameras[0];
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
    controller.dispose();
    super.dispose();
  }

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