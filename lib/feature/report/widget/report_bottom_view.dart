import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_bottom_controller.dart';
import 'package:final_scanner_app/feature/report/view/add_new_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpenseBottomSheet extends StatelessWidget {
  final String text;
  final String rName;
  final int id;
  final String status;
  final TextAlign? textAlign;

  const ExpenseBottomSheet({
    super.key,
    required this.text,
    this.textAlign,
    required this.id,
    required this.status,
    required this.rName,
  });

  @override
  Widget build(BuildContext context) {
    final ExpenseBottomSheetController controller = Get.put(ExpenseBottomSheetController());

    return GestureDetector(
      onTap: () => _openBottomSheet(context, controller),
      child: Container(
        margin: EdgeInsets.all(10),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(width: 1, color: AppColor.greyColor50),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(AppImages.addIcon),
              SizedBox(width: 10),
              Text(
                text,
                textAlign: textAlign,
                style: GoogleFonts.manrope(color: AppColor.dark, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context, ExpenseBottomSheetController controller) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                color: AppColor.light,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSheetHeader(),
                    _buildSearchField(controller),
                    _buildExpenseList(controller),
                    _buildNewReportButton(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetHeader() {
    return Column(
      children: [
        Center(
          child: Container(
            height: 5,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.dark,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AppText.manRope16(text: AppString.addReportText, color: AppColor.dark),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(ExpenseBottomSheetController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: "Search Reports",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: controller.filterExpenses,
      ),
    );
  }

  Widget _buildExpenseList(ExpenseBottomSheetController controller) {
    return Expanded(
      child: Obx(() {
        final dataList = controller.reportController.filteredExpenses.toList();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];
            int reportId = int.tryParse(data['report_id'].toString()) ?? 0;
            controller.reportController.fetchReportData(reportId);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  await controller.updateExpenseReportData(
                    id: int.tryParse(data['id'].toString()) ?? 0,
                    reportId: id,
                    status: status,
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  height: 89,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AppColor.greyColor50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        _buildCategoryIcon(data),
                        SizedBox(width: 25),
                        _buildExpenseDetails(data, reportId, controller),
                        Spacer(),
                        _buildAmountText(data),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildCategoryIcon(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryColor),
      ),
      child: CircleAvatar(
        backgroundColor: AppColor.lightPink1,
        child: Text(data['category_image'] ?? ""),
      ),
    );
  }

  Widget _buildExpenseDetails(Map<String, dynamic> data, int reportId, ExpenseBottomSheetController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.manRope16(text: data['name']),
        AppText.manRope14(
          text: DateFormat("MMM dd, yyyy").format(DateFormat("d.M.yyyy").parse(data['date'].toString())),
        ),
        Obx(() {
          final reportName = controller.reportController.reportDataCache[reportId]?['report_name'] ?? "";
          final color = data['status'] == "Completed"
              ? AppColor.darkGreen
              : data['status'] == "Sent"
              ? AppColor.blueShad
              : AppColor.redColor;

          return AppText.manRope16(text: reportName, color: color);
        }),
      ],
    );
  }

  Widget _buildAmountText(Map<String, dynamic> data) {
    return AppText.manRope16(text: '- ${data['price']} ${data['currency']}');
  }

  Widget _buildNewReportButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewReportView()));
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColor.primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.manRope14(text: AppString.addNewReportText, color: AppColor.light),
            SizedBox(width: 10),
            Image.asset(AppImages.addIcon, color: AppColor.light),
          ],
        ),
      ),
    );
  }
}