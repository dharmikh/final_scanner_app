import 'package:camera/camera.dart' show CameraPreview;
import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/back_navigation_arrow.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/transaction_type_dialogue/camera/controller/custom_camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCameraPage extends StatelessWidget {
  final CustomCameraController cameraController = Get.put(CustomCameraController());

  CustomCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(),
        title: Center(child: AppText.manRope18(text: AppString.scanText, color: AppColor.primaryColor)),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.cameraswitch),
        //     onPressed: () {
        //       Get.find<CustomCameraController>().toggleCamera();
        //     },
        //   ),
        // ],
      ),
      body: Obx(() {
        if (!cameraController.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: OrientationBuilder(
                builder: (context, orientation) {
                  return Transform.rotate(
                    angle: orientation == Orientation.portrait ? 0 : 1.5708,
                    child: CameraPreview(cameraController.cameraController!),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(iconPath: AppImages.gallery, onTap: cameraController.pickFromGallery),
                    GestureDetector(
                      onTap: cameraController.captureImage,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.light, width: 3),
                        ),
                        child: Center(
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.light),
                            child: const Icon(Icons.camera, color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => _buildIconButton(
                        iconPath: cameraController.isFlashOn.value ? AppImages.flash0Icon : AppImages.flash1Icon,
                        onTap: cameraController.toggleFlash,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildIconButton({required String iconPath, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.light),
      child: IconButton(icon: Image.asset(iconPath, height: 24, width: 24), onPressed: onTap),
    );
  }
}
