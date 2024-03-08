import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

var someText = "this is it";

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTFLite();
    initAudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  late AudioPlayer player;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  // var detector;
  var detectedCurrencyIndex;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = await CameraController(
        cameras[0],
        ResolutionPreset.max,
      );

      await cameraController.initialize();
      // .then((value) {
      //   cameraController.startImageStream((image) {
      //     cameraCount++;

      //     if (cameraCount % 100 == 0) {
      //       cameraCount = 0;
      //       objectDetector(image);
      //     }
      //   });
      // });

      isCameraInitialized(true);
      update();
    } else {
      print("permission Denied!");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
  }

  initAudioPlayer() async {
    player = AudioPlayer();

    await player.play(AssetSource('sounds/intro.mp3'));
  }

  playCusAudio() async {
    switch (detectedCurrencyIndex) {
      case '0 10':
        await player.play(AssetSource('sounds/10_r.mp3'));
        break;
      case '1 20':
        await player.play(AssetSource('sounds/20_r.mp3'));
        break;
      case '2 20_old':
        await player.play(AssetSource('sounds/20_r.mp3'));
        break;
      case '3 50':
        await player.play(AssetSource('sounds/50_r.mp3'));
        break;
      case '4 100':
        await player.play(AssetSource('sounds/100_r.mp3'));
        break;
      case '5 200':
        await player.play(AssetSource('sounds/200_r.mp3'));
        break;
      case '6 500':
        await player.play(AssetSource('sounds/500_r.mp3'));
        break;
      default:
        await player.play(AssetSource('sounds/tap_once_more.mp3'));
    }
    // await player.play(AssetSource('sounds/20_r.mp3'));
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) {
          return e.bytes;
        }).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5);

    if (detector != null) {
      // log("Result is $detector");
      someText = detector.toString();
      // print("ffound something! $detector");
    }

    return detector;
  }
}
