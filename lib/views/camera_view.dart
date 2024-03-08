import 'package:netraAi/controller/scan_controller.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'audio_handler.dart'
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraInitialized.value
                ? GestureDetector(
                    onTap: () async {
                      print("camera is clicked!");

                      // controller.cameraController.startImageStream((image) {
                      // controller.objectDetector(image);
                      // });

                      // await player.play(AssetSource("sounds/20_r.mp3"));
                      controller.playCusAudio();
                    },
                    child: CameraPreview(controller.cameraController),
                  )
                : const Center(
                    child: Text("Loading Preview...."),
                  );
          }),
      bottomNavigationBar: Text("something something $someText"),
    );
  }
}

class CameraViewState extends StatefulWidget {
  const CameraViewState({super.key});

  @override
  State<CameraViewState> createState() => _CameraViewStateState();
}

class _CameraViewStateState extends State<CameraViewState> {
  var labelName = "Tap";
  var currencyFound = "";

  handleOnTap(output, controller) async {
    setState(() {
      labelName = output.first['label'].split(" ").last;
      currencyFound = output.first['label'];
      // labelName = output[0].label;
    });

    print("print from handlontap $output");
    // controller.playCusAudio();
    controller.detectedCurrencyIndex = currencyFound;
    // controller.update();
    // update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
        // title: Text("Something something"),
      // ),
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraInitialized.value
                ? GestureDetector(
                    onTap: () async {
                      print("camera is clicked!");

                      var output;

                      controller.cameraController.startImageStream((image) {
                        controller.cameraCount++;

                        if (controller.cameraCount % 10 == 0) {
                          controller.cameraCount = 0;
                          controller.objectDetector(image).then((value) {
                            output = value;
                            handleOnTap(output, controller);
                          });
                        }
                      });

                      // controller.cameraController.

                      // await player.play(AssetSource("sounds/20_r.mp3"));

                      controller.playCusAudio();
                      controller.update();
                      // update();
                    },
                    child: Column(
                      children: [
                        CameraPreview(controller.cameraController),
                        Container(
                          child: Text("$labelName",
                              style: TextStyle(
                                fontSize: 80.0,
                                fontFamily: 'CustomFont',
                                color: Colors.black,
                              )),
                          margin: EdgeInsets.all(16.0),
                          // padding: EdgeInsets.all(16.0),
                          color: Colors.white,
                        ),
                      ],
                    ))
                : const Center(
                    child: Text("Loading Preview...."),
                  );
          }),
      // bottomNavigationBar: Text("currency: $labelName"),
    );
  }
}
