import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/back_navigation_arrow.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/summary/controller/summery_controller.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/feature/transaction/widget%20/report_bottom_sheet.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../transaction_type_dialogue/expense/view/expense_view.dart';

class ViewReceiptData extends StatefulWidget {
  final int id;

  final String title;
  final String date;
  final String amount;
  final String image;
  final String currency;
  final String description;

  const ViewReceiptData({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.image,
    required this.currency,
    required this.description,
    required this.id,
  });

  @override
  State<ViewReceiptData> createState() => _ViewReceiptDataState();
}

class _ViewReceiptDataState extends State<ViewReceiptData> {
  TransactionController transactionController = Get.put(TransactionController());
  SummaryController summaryController = Get.put(SummaryController());

  @override
  void initState() {
    transactionController.getReportData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(),
        title: AppText.manRope18(text: AppString.expense1Text, color: AppColor.primaryColor),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showMyCupertinoDialog(context);
            },
            icon: Image.asset(AppImages.deleteIcon),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColor.greyColor50, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColor.lightPink,
                            border: Border.all(color: AppColor.primaryColor),
                          ),
                          child: Center(child: Text(widget.image, style: TextStyle(fontSize: 45))),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 70),
                    child: IconButton(
                      onPressed: () {
                        Get.to(
                          () => ExpensePage(
                            id: widget.id,
                            name: widget.title,
                            price: widget.amount,
                            date: widget.date,
                            description: widget.description,
                            currency: widget.currency,
                            image: widget.image,
                            pageStatus: "edit",
                          ),
                        );
                      },
                      icon: Image.asset(AppImages.editToolIcon),
                    ),
                  ),
                ],
              ),
            ),
            AppText.manRope16(text: widget.title),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                        width: 363,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: AppColor.light),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
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
                              ListTile(
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColor.lightPink,
                                    border: Border.all(color: AppColor.primaryColor),
                                  ),
                                  child: Image.asset(AppImages.fuelImage),
                                ),
                                title: AppText.manRope16(text: AppString.myFuelText, color: AppColor.dark),
                                subtitle: AppText.manRope14(text: AppString.dateOne, color: AppColor.greyColor50),
                              ),
                              GestureDetector(
                                // onTap: () {
                                //   Navigator.pop(context);
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => BillDataPage()),
                                //   );
                                // },
                                child: Container(
                                  height: MediaQuery.sizeOf(context).height / 2.4,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(child: Image.asset(AppImages.fullBillImage)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  width: 171,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AppColor.greyColor50),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AppText.manRope16(text: AppString.seeReceiptText, color: AppColor.black),
                      Image.asset(AppImages.searchReceipt),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 289,
              //width: 361,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(width: 1, color: AppColor.greyColor50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.manRope16(text: AppString.totalText, color: AppColor.greyColor50),
                        AppText.manRope24600(text: "${widget.amount} ${widget.currency}"),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0), child: Divider(color: AppColor.greyColor50)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.manRope16(text: AppString.dateText, color: AppColor.greyColor50),
                        AppText.manRope24600(
                          text: DateFormat("MMM dd, yyyy").format(DateFormat("d.M.yyyy").parse(widget.date)),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0), child: Divider(color: AppColor.greyColor50)),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 8),
                    child: AppText.manRope16(text: widget.description, color: AppColor.greyColor50),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: AppText.manRope16(text: AppString.noteText, color: AppColor.greyColor50),
                  ),
                ],
              ),
            ),
            Obx(
              () => ReportBottomSheet(
                id: widget.id,
                data: transactionController.reportData.value,
                text: AppString.reportText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMyCupertinoDialog(BuildContext context) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              SizedBox(height: 8),
              Image.asset(AppImages.deleteIcon, height: 50, width: 50),
              SizedBox(height: 8),
              AppText.manRope24600(text: AppString.sureText, color: AppColor.dark),
            ],
          ),
          content: AppText.manRope14(text: AppString.deleteWantText, color: AppColor.dark),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Get.back();
              },
              child: AppText.manRope16(text: AppString.cancelText, color: AppColor.greyColor100),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                await DBHelper.instance.deleteExpense(id: widget.id);
                await transactionController.expensesData();
                summaryController.summaryData();
                summaryController.chengIndex();

                // Show SnackBar using ScaffoldMessenger
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("${widget.title} is Deleted"), duration: Duration(seconds: 2)));

                // Close dialog
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: AppText.manRope16(text: AppString.deleteText, color: AppColor.primaryColor),
            ),
          ],
        );
      },
    );
  }
}
