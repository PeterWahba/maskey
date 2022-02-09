import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';

class HomeController extends GetxController {
  List<CameraDescription>? cameras;

  CameraImage? imgCamera;
  CameraController? cameraController;
  bool isWorking = false;
  RxString result = ''.obs;

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      // if (!mounted) {
      //   return;
      // }
      // setState(() {
      cameraController!.startImageStream((imageFromStream) => {
            if (!isWorking)
              {
                isWorking = true,
                imgCamera = imageFromStream,
                runModelOnFrame(),
                update()
              }
          });
      update();
      // });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  runModelOnFrame() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );
      result.value = '';

      recognitions!.forEach((response) {
        result.value += response["label"] + "\n";
      });
      // setState(() {
      result;
      // });
      isWorking = false;
      update();
    }
  }

  @override
  void onInit() async {
    cameras = await availableCameras();
    super.onInit();
  }

  @override
  void onReady() async {
    initCamera();
    loadModel();
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
