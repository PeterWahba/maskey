import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:maskey/main.dart';
import 'package:tflite/tflite.dart';

// OLD CODE
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CameraImage? imgCamera;
  CameraController? cameraController;
  bool isWorking = false;
  String result = '';
  bool _rear = false;

  initCamera() {
    cameraController =
        CameraController(cameras![_rear ? 0 : 1], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnFrame(),
                }
            });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
    loadModel();
  }

  runModelOnFrame() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 0.0, // defaults to 0.0
        imageStd: 255.0,
        // imageMean: 300.5,
        // imageStd: 300.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );
      result = '';

      recognitions!.forEach((response) {
        result =
            '${response["label"]} ${(response["confidence"] * 100).toStringAsFixed(0)} % \n';
        // result += response["label"] + "\n";
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _switchCameraLens(),
        child: Icon(_rear ? Icons.camera_front : Icons.camera_rear),
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Center(
            child: Text(
              result,
              style: const TextStyle(
                backgroundColor: Colors.black87,
                fontSize: 30.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: size.width,
            height: size.height - 100,
            child: Container(
              height: size.height - 100,
              child: (!cameraController!.value.isInitialized)
                  ? Container()
                  : AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _switchCameraLens() async {
    _rear = !_rear;
    await cameraController?.dispose();
    initCamera();
  }
}

// GETX

// class HomeView extends GetView<HomeController> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Padding(
//           padding: const EdgeInsets.only(top: 40.0),
//           child: Center(
//             child: Obx(
//               () => Text(
//                 controller.result(),
//                 style: const TextStyle(
//                   backgroundColor: Colors.black87,
//                   fontSize: 30.0,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             width: size.width,
//             height: size.height - 100,
//             child: GetBuilder<HomeController>(
//               builder: (_) => Container(
//                 height: size.height - 100,
//                 child: (_.cameraController!.value.isInitialized)
//                     ? Container()
//                     : AspectRatio(
//                         aspectRatio: _.cameraController!.value.aspectRatio,
//                         child: CameraPreview(_.cameraController!),
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }
