import 'package:netraAi/controller/scan_controller.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'audio_handler.dart'
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

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
    double screenWidth = MediaQuery.of(context).size.width - 20;
    double screenHeight = MediaQuery.of(context).size.height - 300;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: const Center(
            child: Text("Netra Ai",
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'CustomFont',
                  color: Colors.black,
                )),
          ),
          toolbarHeight: 100.0,
          // backgroundColor: Colors.transparent,
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(132, 0, 0, 0),
            statusBarBrightness: Brightness.light,
            // statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),

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
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: SizedOverflowBox(
                              size: Size(screenWidth, screenHeight),
                              alignment: Alignment.center,
                              child: CameraPreview(controller.cameraController),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16.0),
                          // padding: EdgeInsets.all(16.0),
                          color: Colors.white,
                          child: Text("$labelName",
                              style: const TextStyle(
                                fontSize: 80.0,
                                fontFamily: 'CustomFont',
                                color: Colors.black,
                              )),
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
