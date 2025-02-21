import 'package:camera/camera.dart';
import 'package:final_scanner_app/feature/transaction_type_dialogue/camera/view/display_captured_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomCameraController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  var isCameraInitialized = false.obs;
  var isFlashOn = false.obs;
  var capturedImage = Rx<XFile?>(null);
  var currentCameraIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  /// Initialize Camera
  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        throw Exception("No cameras available");
      }

      cameraController = CameraController(
        cameras![currentCameraIndex.value],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();

      isCameraInitialized.value = true;
      update(); // Notify UI
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  // /// Toggle between front and back camera
  // Future<void> toggleCamera() async {
  //   if (cameras == null || cameras!.length < 2) return;
  //
  //   currentCameraIndex.value = (currentCameraIndex.value + 1) % cameras!.length;
  //
  //   await cameraController?.dispose(); // Dispose previous camera
  //   await _initializeCamera(); // Initialize new camera
  //   update();
  // }

  /// Toggle Flashlight
  Future<void> toggleFlash() async {
    if (cameraController != null && isCameraInitialized.value) {
      try {
        await cameraController!.setFlashMode(
          isFlashOn.value ? FlashMode.off : FlashMode.torch,
        );
        isFlashOn.toggle();
        update();
      } catch (e) {
        debugPrint("Flash toggle error: $e");
      }
    }
  }

  /// Capture Image from Camera
  Future<void> captureImage() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        cameraController!.value.isTakingPicture) {
      return;
    }

    try {
      final XFile image = await cameraController!.takePicture();
      capturedImage.value = image;
      update();
    } catch (e) {
      debugPrint("Capture error: $e");
    }
  }

  /// Pick Image from Gallery
  Future<void> pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      capturedImage.value = image;
      update();
      Get.to(() => DisplayCapturedImagePage(imagePath: image.path));
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
