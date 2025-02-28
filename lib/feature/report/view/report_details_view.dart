import 'dart:io';
import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/back_navigation_arrow.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/report/controller%20/report_controller.dart';
import 'package:final_scanner_app/feature/report/view/add_new_report.dart';
import 'package:final_scanner_app/feature/report/widget/report_bottom_view.dart';
import 'package:final_scanner_app/feature/transaction/controller/transaction_controller.dart';
import 'package:final_scanner_app/helper/db_helper/db_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

class ReportDetailView extends StatefulWidget {
  final int? id;
  final String colorStatus;
  final String rName;
  final String cName;
  final String amount;
  final String status;
  final String statusImage;
  final String? description;
  final String date;

  const ReportDetailView({
    super.key,
    this.id,
    required this.rName,
    required this.cName,
    required this.amount,
    required this.status,
    required this.statusImage,
    required this.date,
    this.description,
    required this.colorStatus,
  });

  @override
  State<ReportDetailView> createState() => _ReportDetailViewState();
}

class _ReportDetailViewState extends State<ReportDetailView> {
  ReportController reportController = Get.put(ReportController());
  TransactionController transactionController = Get.put(TransactionController());

  Future<void> fetchReportData() async {
    await reportController.reportData();
    await transactionController.expensesData();
    reportController.fetchReportExpenses(widget.id.toString());
    await reportController.getReportData();
  }

  @override
  void initState() {
    fetchReportData();
    super.initState();
  }

  Future<File> generateReportPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Report Details", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Report Name: ${widget.rName}"),
              pw.Text("Client Name: ${widget.cName}"),
              pw.Text("Amount: ${widget.amount}"),
              pw.Text("Status: ${widget.status}"),
              pw.Text("Date: ${widget.date}"),
              if (widget.description != null && widget.description!.isNotEmpty)
                pw.Text("Description: ${widget.description}"),
              pw.SizedBox(height: 20),
              pw.Text("Generated using Scanner App", style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${widget.rName}.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  Future<void> shareReportPDF() async {
    final file = await generateReportPDF();
    await Share.shareXFiles([XFile(file.path)], text: "Check out this report: ${widget.rName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomIconButton(
          onPress: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: AppText.manRope18(text: AppString.report, color: AppColor.primaryColor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColor.greyColor50, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AppText.manRope16(text: widget.date, color: AppColor.greyColor50),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AppText.manRope24600(text: widget.rName, color: AppColor.darkGreen),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Obx(() {
                      double totalAmount = reportController.calculateTotalAmount();
                      return AppText.manRope24600(text: totalAmount.toString(), color: AppColor.dark);
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 35,
                      width: 114,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),
                        border: Border.all(color: AppColor.darkGreen),
                        color: AppColor.lightGreen,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(widget.statusImage, color: AppColor.dark),
                          const SizedBox(width: 5),
                          AppText.manRope14(text: widget.status, color: AppColor.dark),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AppText.manRope16(text: AppString.noteText, color: AppColor.greyColor50),
                  ),
                  Obx(() {
                    if (reportController.reportExpenseMapData.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("No expenses found for this report."),
                        ),
                      );
                    }
                    final groupedEntries = reportController.reportExpenseMapData.entries.toList();
                    //print(groupedEntries);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(groupedEntries.length, (outerIndex) {
                        final entry = groupedEntries[outerIndex];
                        final String monthYear = entry.key;
                        final List<Map<String, dynamic>> expenses = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.manRope24600(text: monthYear, color: AppColor.dark),
                                  if (outerIndex == 0)
                                    TextButton(
                                      onPressed: () {},
                                      child: AppText.manRope16(text: AppString.select, color: AppColor.greyColor50),
                                    ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: expenses.length,
                              itemBuilder: (context, innerIndex) {
                                var expense = expenses[innerIndex];
                                return Container(
                                  height: 89,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(color: AppColor.greyColor50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColor.primaryColor),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: AppColor.lightPink1,
                                            child: Text(expense['category_image']),
                                          ),
                                        ),
                                        SizedBox(width: 25),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AppText.manRope16(text: expense['name']),
                                            AppText.manRope14(
                                              text: DateFormat(
                                                "MMM dd, yyyy",
                                              ).format(DateFormat("d.M.yyyy").parse("${expense['date']}")),
                                            ),
                                            AppText.manRope16(
                                              text: widget.rName,
                                              color:
                                                  widget.colorStatus == "Completed"
                                                      ? AppColor.darkGreen
                                                      : widget.colorStatus == "Sent"
                                                      ? AppColor.blueShad
                                                      : AppColor.redColor,
                                              // expense['status'] == "Completed"
                                              //     ? AppColor.darkGreen
                                              //     : expense['status'] == "Sent"
                                              //     ? AppColor.blueShad
                                              //     : AppColor.redColor,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        AppText.manRope16(text: '- ${expense['price']} ${expense['currency']}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }),
                    );
                  }),
                  ExpenseBottomSheet(id: widget.id ?? 0, text: AppString.newReportText, status: widget.status),
                ],
              ),
            ),
          ),
          Material(
            elevation: 5,
            color: Colors.transparent,
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.light,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, -1),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => NewReportView(
                                  id: widget.id,
                                  status: widget.status,
                                  reportName: widget.rName,
                                  description: widget.description,
                                  //description: widget.,
                                  clientName: widget.cName,
                                  reportPageStatus: "edit",
                                ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Column(
                          children: [
                            Image.asset(AppImages.editToolIcon, color: AppColor.dark),
                            AppText.manRope14(text: AppString.editText, color: AppColor.dark),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: shareReportPDF,
                      child: SizedBox(
                        //  color: AppColor.primaryColor,
                        height: 60,
                        width: 80,
                        child: Column(
                          children: [
                            Image.asset(AppImages.pdfIcon, color: AppColor.dark),
                            AppText.manRope14(text: AppString.shareText, color: AppColor.dark),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await showMyCupertinoDialog(context);
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Column(
                          children: [
                            Image.asset(AppImages.deleteIcon, color: AppColor.primaryColor),
                            AppText.manRope14(text: AppString.deleteText, color: AppColor.dark),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
              AppText.manRope24500(text: AppString.sureText, color: AppColor.dark),
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
                await DBHelper.instance.deleteReport(id: widget.id!);
                await transactionController.expensesData();
                Get.snackbar("Hello User", "${widget.rName} is Delete");

                Get.back();
                Get.back();
              },
              child: AppText.manRope16(text: AppString.deleteText, color: AppColor.primaryColor),
            ),
          ],
        );
      },
    );
  }
}
