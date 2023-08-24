// import 'dart:typed_data';

// import 'package:tflite_flutter/tflite_flutter.dart';

// class TfliteFlutterModel {
//   static Interpreter? interpreter;
//   String tfliteModelPath = 'assets/models/model_unquant.tflite';
//   List<List<double>> inputData = [];

//   List<double> outputData = [];
//   // Load the tflite model
//   loadModel() async {
//     Interpreter interpreter = await Interpreter.fromAsset(tfliteModelPath);
//     interpreter.allocateTensors();

//     // Set up your input tensor(s)
//     Tensor input = interpreter.getInputTensor(0);
//     input.copyTo(Float32List.fromList(inputData.flatten()).buffer);

//     // Run inference
//     interpreter.invoke();
//     outputData[0] = interpreter.getOutputIndex('Brain Tumor').toDouble();
//   }
// }
