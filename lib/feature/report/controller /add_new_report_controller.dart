import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../transaction_type_dialogue/expense/controller /expense_controller.dart';

class NewReportController extends GetxController {
  // TextEditingControllers for form fields
  TextEditingController reportNameTxt = TextEditingController();
  TextEditingController reportClientNameTxt = TextEditingController();
  TextEditingController reportDescriptionTxt = TextEditingController();

  // Selected status index
  var selectedStatusIndex = 0.obs;

  // List of status options
  final List<String> textData = [AppString.unsentText, AppString.sentText, AppString.completedText];

  // List of status icons
  final List<String> statusData = [AppImages.unsentImage, AppImages.sentImage, AppImages.saveIcon];

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // ReportController and ExpenseController instances
  final ReportController reportController = Get.put(ReportController());
  final TransactionController transactionController = Get.put(TransactionController());

  // Initialize the controller with existing data (if editing)
  void initializeData({String? reportName, String? clientName, String? description, String? status}) {
    reportNameTxt.text = reportName ?? "";
    reportClientNameTxt.text = clientName ?? "";
    reportDescriptionTxt.text = description ?? "";

    // Set the selected status index based on the provided status
    if (status != null) {
      selectedStatusIndex.value = textData.indexOf(status);
    }
  }

  // Save or update the report
  Future<void> saveOrUpdateReport({required String reportPageStatus, int? id}) async {
    if (formKey.currentState!.validate()) {
      String formattedDate = DateFormat('d.M.y').format(DateTime.now());
      final selectedStatus = textData[selectedStatusIndex.value];
      final selectedStatusImage = statusData[selectedStatusIndex.value];

      if (reportPageStatus == "add") {
        await DBHelper.instance.insertReport(
          reportName: reportNameTxt.text,
          reportClientName: reportClientNameTxt.text,
          reportDescription: reportDescriptionTxt.text,
          reportStatusImage: selectedStatusImage,
          reportStatus: selectedStatus,
          date: formattedDate,
        );

        // Refresh data in other controllers
        await reportController.reportData();
        await transactionController.expensesData();
        await reportController.getReportData();
      } else if (reportPageStatus == "edit") {
        await DBHelper.instance.updateReport(
          reportName: reportNameTxt.text,
          clientName: reportClientNameTxt.text,
          description: reportDescriptionTxt.text,
          statusImage: selectedStatusImage,
          status: selectedStatus,
          date: formattedDate,
          id: id ?? 0,
        );

        await reportController.reportData();
        await transactionController.expensesData();
        await reportController.getReportData();
      }

      // Close the current screen
      Get.back();
      Get.back();
    }
  }

  // Dispose controllers when no longer needed
  @override
  void onClose() {
    reportNameTxt.dispose();
    reportClientNameTxt.dispose();
    reportDescriptionTxt.dispose();
    super.onClose();
  }
}
