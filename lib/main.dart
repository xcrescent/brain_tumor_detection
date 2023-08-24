import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() {
    devtools.log(this.toString());
  }
}

// log the current state
// void logState(String state) {
//   print('Current state: $state');
// }
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;
  File? _image;
  List _ouptut = [];
  final picker = ImagePicker();
  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  detectImage(File? image) async {
    var output = await Tflite.runModelOnImage(
      path: image!.path,
      // numResults: 1,
      // threshold: 1.0,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _ouptut = output!;
    });
  }

  // Load the tflite model
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/models/model_unquant_metadata.tflite",
      labels: "assets/models/labels.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  // // Pick an image from the gallery
  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       imagepath = pickedFile.path;
  //       _imageBytes = File(imagepath).readAsBytesSync();
  //       _runInference();
  //     });
  //   }
  // // }

  // // Run inference on the image
  // Future<void> _runInference() async {
  //   if (_imageBytes == null) return;

  //   // Set up your input tensor(s)
  //   // var inputShape = Tflite..getInputShape(0);
  //   // var inputType = Tflite.getInputType(0);
  //   // var input = _imageBytes.buffer.asFloat32List();
  //   // var inputs = <String, dynamic>{};
  //   // inputs[Tflite.getInputName(0)] = input;

  //   // Run inference
  //   try {
  //     var outputs = await Tflite.runModelOnImage(
  //       path: imagepath,
  //       numResults: 1,
  //       threshold: 0.5,
  //       imageMean: 127.5,
  //       imageStd: 127.5,

  //       // inputs: inputs,
  //       // outputs: [0],
  //       // inputType: inputType,
  //       // inputShape: inputShape,
  //     );
  //     _outputData = outputs![0];
  //     setState(() {});
  //   } on Exception catch (e) {
  //     print('Failed to run inference: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('TFLite Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image != null
                  ? Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                    )
                  : Text('No image selected.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick an image'),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _ouptut == null ? null : _runInference,
              //   child: Text('Run inference'),
              // ),
              SizedBox(height: 20),
              _ouptut.isNotEmpty
                  ? Text(
                      '${_ouptut[0]['label']}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
