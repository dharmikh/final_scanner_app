import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  var currentRating = 0.0.obs;

  void updateRating(double rating) {
    currentRating.value = rating;
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "Thank You! You rated ${currentRating.value} stars!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void navigateToHomePage() {
    Get.offAllNamed('/home');
  }
}
