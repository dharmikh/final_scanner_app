import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseBottomSheetController extends GetxController {
  // Controllers
  TextEditingController searchController = TextEditingController();

  // Other controllers
  final TransactionController transactionController = Get.find();
  final ReportController reportController = Get.find();

  // Fetch data
  Future<void> fetchData() async {
    await reportController.expensesToReportData();
    await reportController.reportData();
    await transactionController.expensesData();
  }

  // Filter expenses based on search query
  void filterExpenses(String query) {
    reportController.filterExpenses(query);
  }


  // Update expense report data
  Future<void> updateExpenseReportData({
    required int id,
    required int reportId,
    required String status,
  }) async {
    await DBHelper.instance.updateExpenseReportData(
      id: id,
      reportId: reportId,

    );

    await reportController.expensesToReportData();
    await transactionController.expensesData();
    await reportController.fetchReportExpenses(reportId.toString());

    Get.snackbar(
      "Success",
      "Data Successfully Added",
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColor.dark,
      colorText: AppColor.light,
      duration: Duration(seconds: 3),
    );
  }

  // Dispose controllers when no longer needed
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}